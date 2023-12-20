require 'yaml'

require 'izwu/expectation'

module Izwu
  module Config
    class << self
      def load_expectations
        conf = YAML.safe_load_file(find_conf_file)

        conf['expectations'].reduce Hash.new do |result, e|
          e = Izwu::Expectation.load_from_conf(e)
          result[e.name] = e
          result
        end
      end

      def find_conf_file
        xdg_conf_path = "#{ENV['XDG_CONFIG_HOME']}/izwu/izwu.yaml"
        default_conf_path = "#{ENV['HOME']}/.config/izwu/izwu.yaml"

        File.exist?(xdg_conf_path) ?
          xdg_conf_path : default_conf_path
      end
    end
  end
end
