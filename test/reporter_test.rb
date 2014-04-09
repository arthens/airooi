require_relative '../lib/airooi'
require "minitest/autorun"

class TestReporter < Minitest::Test

  def test_add
    reporter = Airooi::Reporter.new()

    reporter.add(Airooi::Reporter::INFO, "Table x is ok")
    reporter.add(Airooi::Reporter::INFO, "Table y is ok")
    reporter.add(Airooi::Reporter::WARN, "Table y is ok")

    assert_equal 3, reporter.reports(Airooi::Reporter::INFO).count
  end

  def test_filter_by_level
    reporter = Airooi::Reporter.new()

    reporter.add(Airooi::Reporter::INFO, "Table x is ok")
    reporter.add(Airooi::Reporter::INFO, "Table y is ok")
    reporter.add(Airooi::Reporter::WARN, "Table z is not ok")
    reporter.add(Airooi::Reporter::ERROR, "Table a is full")

    assert_equal 4, reporter.reports(Airooi::Reporter::INFO).count
    assert_equal 2, reporter.reports(Airooi::Reporter::WARN).count
    assert_equal 1, reporter.reports(Airooi::Reporter::ERROR).count
  end 
end
