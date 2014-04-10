require_relative '../lib/airooi'
require "minitest/autorun"
require "minitest/mock"

class TestColumn < Minitest::Test

  def setup
    @dao_mock = MiniTest::Mock.new
    @analyzer = Airooi::Column.new(@dao_mock)
  end

  def test_check_max_value_when_full
    setup_mock(100, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Report::ERROR, ret[0]
    assert ret[1].include?("100%")
  end

  def test_check_max_value_when_80
    setup_mock(80, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Report::WARN, ret[0]
    assert ret[1].include?("80%")
  end

  def test_check_max_value_when_50
    setup_mock(50, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Report::INFO, ret[0]
    assert ret[1].include?("50%")
  end

  def test_check_max_value_when_empty
    setup_mock(0, 100)
    ret = @analyzer.check_max_value("news", "id")

    assert_equal Airooi::Report::INFO, ret[0]
    assert ret[1].include?("0%")
  end

  def test_level_for
    assert_equal Airooi::Report::INFO, @analyzer.level_for(0)
    assert_equal Airooi::Report::INFO, @analyzer.level_for(10)
    assert_equal Airooi::Report::INFO, @analyzer.level_for(74.9)
    assert_equal Airooi::Report::WARN, @analyzer.level_for(75)
    assert_equal Airooi::Report::WARN, @analyzer.level_for(99.9)
    assert_equal Airooi::Report::ERROR, @analyzer.level_for(100)
  end

  def setup_mock(max_value, max_allowed_value)
    @dao_mock.expect :column_info, "int", ["news", "id"]
    @dao_mock.expect :max_value, max_value, ["news", "id"]
    @dao_mock.expect :max_allowed_value, max_allowed_value, ["int"]
  end

end
