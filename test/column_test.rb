require_relative '../lib/airooi'
require "minitest/autorun"
require "minitest/mock"

class TestColumn < Minitest::Test

  def setup
    @dao_mock = MiniTest::Mock.new
    @analyzer = Airooi::Column.new(@dao_mock)
  end

  def test_check_max_value_when_full
    setup_mock(150, 150)
    assert_equal 100, @analyzer.check_max_value("news", "id")
  end

  def test_check_max_value_when_80
    setup_mock(160, 200)
    assert_equal 80, @analyzer.check_max_value("news", "id")
  end

  def test_check_max_value_when_50
    setup_mock(100, 200)
    assert_equal 50, @analyzer.check_max_value("news", "id")
  end

  def test_check_max_value_when_empty
    setup_mock(0, 100)
    assert_equal 0, @analyzer.check_max_value("news", "id")
  end

  def setup_mock(max_value, max_allowed_value)
    @dao_mock.expect :max_value, max_value, ["news", "id"]
    @dao_mock.expect :max_allowed_value, max_allowed_value, ["news", "id"]
  end

end
