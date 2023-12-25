require 'minitest/autorun'

require 'izwu/alpm_ver'


describe Izwu::AlpmVer do
  AlpmVer = Izwu::AlpmVer

  describe "The version 1:2.3.4-5 compares" do
    before do
      @v = Izwu::AlpmVer.parse_full_ver('1:2.3.4-5')
    end

    it "doesn't compare to version string yet" do
      assert_nil Izwu::AlpmVer.cmp(@v, '1.0')
      assert_nil @v <=> '1.0'
    end

    def assert_compares(other, result)
      assert_equal result, Izwu::AlpmVer.cmp(
        @v,
        Izwu::AlpmVer.parse_full_ver(other)
      ).to_a
    end

    it "is greater than epoch-less version" do
      assert_compares '2.3.4-5', [1, :epoch]
    end

    it "is lesser than v3" do
      assert_compares '1:3.0.0-1', [-1, :major]
    end

    it "is greater than incomplete version" do
      assert_compares '1:2.3', [1, :patch]
    end

    it "is equal with extra .0" do
      assert_compares '1:2.3.4.0-5', [0, nil]
    end
  end

  describe "alphanumeric example in vercmp(8)" do
    before do
      example = "1.0a < 1.0b < 1.0beta < 1.0p < 1.0pre < 1.0rc < 1.0 < 1.0.a < 1.0.1"
      @versions = example.split(" < ").map do |v|
        Izwu::AlpmVer.parse_full_ver(v)
      end
    end

    it "works?" do
      skip "Alphanumeric version not supported yet"
      @versions.size.times.drop(1).each do |i|
        assert_operator @versions[i - 1], :<, @versions[i], "i is #{i}"
      end
    end
  end

  describe "a 4-segment version 1.2.3.4-1" do
    subject {"1.2.3.4-1"}

    before do
      @v4 = AlpmVer.parse_full_ver(subject)
    end

    it "is less than 1.2.3.5-1" do
      v5 = AlpmVer.parse_full_ver("1.2.3.5-1")
      refute_equal @v4, v5
      assert_operator @v4, :<, v5
    end
  end
end
