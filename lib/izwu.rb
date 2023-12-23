require 'izwu/alpm_ver'
require 'izwu/config'
require 'izwu/expac'

module Izwu
  DEFAULT_CHANGE = 'pkgrel'
  ENUM_CHANGE = {
    epoch: 10,
    major: 9,
    minor: 8,
    patch: 7,
    pkgrel: 5,
  }

  Package = Struct.new('Package', :name, :repo, :version)

  class << self
    def calc_matches(expectations, local, syncdb)
      syncdb.map do |pkg|
        n = pkg.name
        next if not local.has_key?(n)

        dbver = AlpmVer.parse_full_ver(pkg.version)
        localver = AlpmVer.parse_full_ver(local[n].version)

        expectation = expectations[n]
        if expectation.met?(localver, dbver)
          pkg
        else
          nil
        end
      end.reject!(&:nil?)
    end

    def init
      Config.write_example_conf!
    end

    def main(subcmd)
      return init() if subcmd == "init"

      expectations = Config.load_expectations
      local = Expac.get_local_pkgs(expectations.keys)
      syncdb = Expac.get_syncdb_pkgs(expectations.keys)
      matches = calc_matches(expectations, local, syncdb)
      print_matches(matches)
      exit_with_matches(matches)
    end

    def main!(*args)
      exit(main(*args))
    end

    def print_matches(matches)
      matches.each do |m|
        puts "#{m.repo}/#{m.name} #{m.version}"
      end
    end

    def exit_with_matches(matches)
      matches.empty? ? 1 : 0
    end

  end
end
