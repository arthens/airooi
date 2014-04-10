require_relative '../lib/airooi'
require "minitest/autorun"
require "minitest/mock"

class TestColumnAnalyzer < Minitest::Test

  def setup
    @daoMock = MiniTest::Mock.new
    @analyzer = Airooi::ColumnAnalyzer.new(@daoMock)
  end

  def test_check_max_value_when_full
    setup_mock(100, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Reporter::ERROR, ret[0]
    assert ret[1].include?("100%")
  end

  def test_check_max_value_when_80
    setup_mock(80, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Reporter::WARN, ret[0]
    assert ret[1].include?("80%")
  end

  def test_check_max_value_when_50
    setup_mock(50, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Reporter::INFO, ret[0]
    assert ret[1].include?("50%")
  end

  def test_check_max_value_when_empty
    setup_mock(0, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Reporter::INFO, ret[0]
    assert ret[1].include?("0%")
  end

  def test_level_for
    assert_equal Airooi::Reporter::INFO, @analyzer.level_for(0)
    assert_equal Airooi::Reporter::INFO, @analyzer.level_for(10)
    assert_equal Airooi::Reporter::INFO, @analyzer.level_for(74.9)
    assert_equal Airooi::Reporter::WARN, @analyzer.level_for(75)
    assert_equal Airooi::Reporter::WARN, @analyzer.level_for(99.9)
    assert_equal Airooi::Reporter::ERROR, @analyzer.level_for(100)
  end

  def setup_mock(max_value, max_allowed_value)
    @daoMock.expect :column_info, "int", ["news", "id"]
    @daoMock.expect :max_value, max_value, ["news", "id"]
    @daoMock.expect :max_allowed_value, max_allowed_value, ["int"]
  end

end
