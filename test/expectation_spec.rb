require 'minitest/autorun'

require 'izwu/alpm_ver'
require 'izwu/expectation'

describe Izwu::Expectation do
  describe :new do
    it "raises error on wrong @change" do
      assert_raises ArgumentError do
        Izwu::Expectation.new('foo', :badvalue)
      end
    end

    before do
      @e1 = Izwu::Expectation.new("foo", :pkgrel)
      @e2 = Izwu::Expectation.new("foo")
    end

    it "can create object with mission default values" do
      assert_equal @e1, @e2
    end

    describe :load_from_conf do
      before do
        @e3 = Izwu::Expectation.load_from_conf({
          "name" => "foo",
          "change" => "pkgrel",
        })

        @e4 = Izwu::Expectation.load_from_conf("foo")
      end

      it "can create object from loaded YAML config" do
        assert_equal @e1, @e3
        assert_equal @e2, @e4
      end
    end
  end

  describe "Expecting minor version change of pkg foo" do
    before do
      @e = Izwu::Expectation.new('foo', :minor)
    end

    it "can be met with 1.1 -> 1.2" do
      assert @e.met?(
        Izwu::AlpmVer.parse_full_ver('1.1-1'),
        Izwu::AlpmVer.parse_full_ver('1.2-1')
      )
    end

    it "can be met with 1.1 -> 2.0" do
      assert @e.met?(
        Izwu::AlpmVer.parse_full_ver('1.1-5'),
        Izwu::AlpmVer.parse_full_ver('2.0-1')
      )
    end

    it "can be met with epoch bump" do
      assert @e.met?(
        Izwu::AlpmVer.parse_full_ver('1.1-5'),
        Izwu::AlpmVer.parse_full_ver('1:1.0-1')
      )
    end

    it "can't be met with 1.2.3 -> 1.2.4" do
      refute @e.met?(
        Izwu::AlpmVer.parse_full_ver('1.2.3-1'),
        Izwu::AlpmVer.parse_full_ver('1.2.4-1')
      )
    end
  end
end
