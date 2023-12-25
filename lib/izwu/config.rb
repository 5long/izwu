require 'pathname'
require 'yaml'

require 'izwu/expectation'

module Izwu
  module Config
    EXAMPLE = Pathname.new(__dir__).join('example-config.yaml')

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
        FileUtils.cp EXAMPLE, fn
        puts "Created example config file #{fn}"

        exit 0
      end
    end
  end
end
