require_relative '../lib/airooi'
require "minitest/autorun"

class TestReport < Minitest::Test

  def test_add
    reporter = Airooi::Report.new()

    reporter.add(Airooi::Report::INFO, "Table x is ok")
    reporter.add(Airooi::Report::INFO, "Table y is ok")
    reporter.add(Airooi::Report::WARN, "Table y is ok")

    assert_equal 3, reporter.logs.count
  end

  def test_filter
    reporter = Airooi::Report.new()

    reporter.add(Airooi::Report::INFO, "Table x is ok")
    reporter.add(Airooi::Report::INFO, "Table y is ok")
    reporter.add(Airooi::Report::WARN, "Table z is not ok")
    reporter.add(Airooi::Report::ERROR, "Table a is full")

    assert_equal 4, reporter.filter(Airooi::Report::INFO).count
    assert_equal 2, reporter.filter(Airooi::Report::WARN).count
    assert_equal 1, reporter.filter(Airooi::Report::ERROR).count
  end
end
