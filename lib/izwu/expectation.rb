require 'izwu/alpm_ver'

module Izwu
  class Expectation
    attr_reader :name, :change

    DEFAULT_CHANGE = 'pkgrel'
    # I could've use ruby-enum
    # Or just keep it simple (and messy) to reduce dependency
    ENUM_CHANGE = {
      epoch: 10,
      major: 9,
      minor: 8,
      patch: 7,
      pkgrel: 5,
    }

    def initialize(name, change = nil)
      @name = name
      @change = (change || :pkgrel).to_sym
      validate!
    end

    def validate!
      if not ENUM_CHANGE.has_key?(self.change)
        raise ArgumentError, "#{name} has an invalid value of change: #{change}. Must be one of #{ENUM_CHANGE.keys}"
      end
    end

    def met?(pkg_local, pkg_db)
      cmp = AlpmVer.cmp(pkg_local, pkg_db)
      cmp.result == -1 &&
        ENUM_CHANGE[cmp.change] >= ENUM_CHANGE[self.change]
    end

    def ==(other)
      name == other.name && change == other.change
    end

    class << self
      def load_from_conf(hash_or_str)
        if hash_or_str.is_a? String
          new_from_string(hash_or_str)
        else
          new_from_hash(hash_or_str)
        end
      end

      def new_from_hash(hash)
        new(hash['name'], hash['change'])
      end

      alias_method :new_from_string, :new
    end
  end
end
