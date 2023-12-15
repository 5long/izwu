require 'yaml'

require 'izwu/expectation'

module Izwu
  module Config
    class << self
      def load_expectations
        conf = YAML.safe_load_file "#{ENV['HOME']}/.config/izwu/izwu.yaml"

        conf['expectations'].reduce Hash.new do |result, e|
          e = Izwu::Expectation.load_from_conf(e)
          result[e.name] = e
          result
        end
      end
    end
  end
end
