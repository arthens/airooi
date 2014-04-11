require_relative '../lib/airooi'
require "minitest/autorun"
require "minitest/mock"

class TestTable < Minitest::Test

  def setup
    @driver_mock = MiniTest::Mock.new
    @column_mock = MiniTest::Mock.new
    @analyzer = Airooi::Table.new(@driver_mock, @column_mock)
  end

  def test_analyze_table
    @driver_mock.expect :numeric_columns, ["id", "external_id", "count"], ["news"]
    @column_mock.expect :check_max_value, 100, ["news", "id"]
    @column_mock.expect :check_max_value, 85, ["news", "external_id"]
    @column_mock.expect :check_max_value, 21, ["news", "count"]

    report = @analyzer.analyze_table("news")

    assert_equal 3, report.logs.count
    assert_equal 100, report.logs[0][:used]
    assert_equal 85, report.logs[1][:used]
    assert_equal 21, report.logs[2][:used]

    # Empty reports are expected if the table doesn't contain numeric fields
    @driver_mock.expect :numeric_columns, [], ["news"]
    assert @analyzer.analyze_table("news").logs.empty?
  end

  def test_analyze_database
    @driver_mock.expect :tables, ["news", "article"], []

    @driver_mock.expect :numeric_columns, ["id"], ["news"]
    @column_mock.expect :check_max_value, 10, ["news", "id"]

    @driver_mock.expect :numeric_columns, ["id"], ["article"]
    @column_mock.expect :check_max_value, 100, ["article", "id"]

    reports = @analyzer.analyze_database()
    assert_equal 2, reports.count
    assert_equal ["news", "article"], reports.keys
  end

  def setup_mock(max_value, max_allowed_value)
    @driver_mock.expect :column_info, "int", ["news", "id"]
    @driver_mock.expect :max_value, max_value, ["news", "id"]
    @driver_mock.expect :max_allowed_value, max_allowed_value, ["int"]
  end

end
