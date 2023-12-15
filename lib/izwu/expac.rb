require 'open3'

module Izwu
  module Expac
    class << self
      def get_local_pkgs(pkgs)
        cmd = ['expac', '-Q', '%n %r %v'] + pkgs
        out, _status = Open3.capture2(*cmd)
        out.each_line.reduce Hash.new do |result, line|
          pkg = parse_pkg_line(line)
          result[pkg.name] = pkg
          result
        end
      end

      def parse_pkg_line(line)
        Package.new(*line.split)
      end

      def get_syncdb_pkgs(pkgs)
        cmd = ['expac', '-S', '%n %r %v'] + pkgs
        out, _status = Open3.capture2(*cmd)
        out.each_line.map do |line|
          parse_pkg_line(line)
        end
      end
    end
  end
end
