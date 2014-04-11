require_relative '../lib/airooi'
require "minitest/autorun"

class TestReport < Minitest::Test

  def test_level_for
    report = Airooi::Report.new()

    assert_equal Airooi::Report::INFO, report.level_for(0)
    assert_equal Airooi::Report::INFO, report.level_for(10)
    assert_equal Airooi::Report::INFO, report.level_for(74.9)
    assert_equal Airooi::Report::WARN, report.level_for(75)
    assert_equal Airooi::Report::WARN, report.level_for(99.9)
    assert_equal Airooi::Report::ERROR, report.level_for(100)
  end

  def test_add
    report = Airooi::Report.new()

    report.add("1d", 10)
    report.add("author_id", 5)
    report.add("count", 81)

    assert_equal 3, report.logs.count
    assert_equal Airooi::Report::INFO, report.logs[0][:level]
    assert_equal Airooi::Report::INFO, report.logs[1][:level]
    assert_equal Airooi::Report::WARN, report.logs[2][:level]
  end

  def test_filter
    report = Airooi::Report.new()

    report.add("1d", 10)
    report.add("author_id", 5)
    report.add("count", 81)
    report.add("external_id", 100)

    assert_equal 4, report.filter(Airooi::Report::INFO).count
    assert_equal 2, report.filter(Airooi::Report::WARN).count
    assert_equal 1, report.filter(Airooi::Report::ERROR).count
  end
end

# Marking level_for public so that we can test it
module Airooi
  class Report
    public :level_for

  end
end
