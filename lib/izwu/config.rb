require 'pathname'
require 'yaml'

require 'izwu/expectation'

module Izwu
  module Config
    EXAMPLE = <<~EOF
    ---
    # An example config file for izwu
    # Located at $XDG_CONFIG_HOME/izwu/izwu.yaml by default

    ## Contains a single `expectations:` array
    expectations:

    # Expects that linux bumps a minor version to be worthy of an OS upgrade.
    # A major version bump (e.g. 5.19.z => 6.0) would also trigger
    # this rule
    - name: linux
      change: minor

    # Some packages' versions are product marketing material
    # where only a major bump is interesting
    - name: nvidia
      change: major
    - name: firefox
      change: major

    # Security-critical packages: A patch bump is big enough for
    # a full upgrade
    - name: openssl
      change: patch

    # Some packages' patch releases could contain new feature
    - name: devtools
      change: patch

    # Some pacakges are so critical for Arch that you want to
    # fully upgrade even when only pkgrel bumps
    - name: archlinux-keyring
      change: pkgrel
    # Same as `change: pkgrel`, but a convenient shorthand:
    - base
    - base-devel
    # Same as above, but omitting `change:`
    # since `change:` defaults to `pkgrel`
    - name: filesystem
EOF

    class << self
      def load_expectations
        fn = find_conf_file()
        begin
          conf = YAML.safe_load_file(fn)
        rescue
          $stderr.puts "Config file #{fn} missing. Run `izwu init` to generate an example config."
          exit 3
        end

        conf['expectations'].reduce Hash.new do |result, e|
          e = Izwu::Expectation.load_from_conf(e)
          result[e.name] = e
          result
        end
      end

      def find_conf_file
        if ENV.has_key? "XDG_CONFIG_HOME"
          "#{ENV['XDG_CONFIG_HOME']}/izwu/izwu.yaml"
        else
          "#{ENV['HOME']}/.config/izwu/izwu.yaml"
        end
      end

      def write_example_conf!
        fn = find_conf_file
        if File.exists? fn
          $stderr.puts "Config file #{fn} exists, won't overwrite."

          exit 2
        end

        Pathname.new(fn).parent.mkpath
        File.write fn, EXAMPLE
        puts "Created example config file #{fn}"

        exit 0
      end
    end
  end
end
