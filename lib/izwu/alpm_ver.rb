module Izwu
  class AlpmVer < Struct.new('AlpmVer', :epoch, :pkgver, :pkgrel)
    REGEXP_EPOCH = /^(\d+):/
    REGEXP_PKGREL = /-(\d+)$/
    PKGVER_SEGMENTS = %i{major minor patch seg4th seg5th seg6th}
    CHANGE_KEYS = [:epoch] + PKGVER_SEGMENTS + [:pkgrel]

    CmpResult = Struct.new('CmpResult', :result, :change)

    class << self
      def parse_full_ver(full_ver)
        epoch = REGEXP_EPOCH.match(full_ver)&.[](1)
        pkgrel = REGEXP_PKGREL.match(full_ver)&.[](1)
        pkgver = full_ver.sub(REGEXP_EPOCH, '').sub(REGEXP_PKGREL, '')

        self.new(epoch&.to_i || 0, pkgver, pkgrel&.to_i || 0)
      end

      def cmp(left, right)
        CHANGE_KEYS.each do |k|
          begin
            num_cmp_result = left.send(k) <=> right.send(k)
          rescue NoMethodError
            return nil
          end

          next if num_cmp_result == 0

          return CmpResult.new(num_cmp_result, k)
        end

        CmpResult.new(0, nil)
      end
    end

    include Comparable
    def <=>(other)
      self.class.cmp(self, other)&.[](0)
    end

    def segments
      @segments ||= pkgver.split('.')
    end

    def segment_count
      segments.count
    end

    PKGVER_SEGMENTS.each_with_index do |s, i|
      define_method s do
        segments[i]&.to_i || 0
      end
    end
  end
end
