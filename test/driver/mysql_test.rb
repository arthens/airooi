require_relative '../../lib/airooi'
require "minitest/autorun"
require 'mysql2'

class TestMysqlDriver < Minitest::Test

  def setup
    @client = Mysql2::Client.new(
      :host => "localhost",
      :username => "root",
      :password => "",
    )

    @client.query("DROP DATABASE IF EXISTS airooi_test;")
    @client.query("CREATE DATABASE airooi_test;")
    @client.select_db("airooi_test")
    @client.query(File.read File.expand_path("../../fixture/test_table_1.sql", __FILE__))
    @client.query(File.read File.expand_path("../../fixture/test_table_2.sql", __FILE__))

    @driver = Airooi::Driver::Mysql.new(@client)
  end

  def test_tables
    tables = @driver.tables()

    assert_equal 2, tables.count
    assert_equal ["article", "user"], tables
  end

  def test_numeric_columns
    assert_equal ["id", "external_id", "author_id", "count"], @driver.numeric_columns("article")
  end

  def test_max_value
    @client.query("INSERT INTO article VALUES (100, 200, 300, 2, 'Hello', 'There');")

    assert_equal 100, @driver.max_value("article", "id")
    assert_equal 200, @driver.max_value("article", "external_id")
    assert_equal 300, @driver.max_value("article", "author_id")
    assert_equal 2, @driver.max_value("article", "count")
  end

  def test_max_allowed_value
    assert_equal 8388607, @driver.max_allowed_value_per_type("mediumint(7)")
    assert_equal 16777215, @driver.max_allowed_value_per_type("mediumint(7) unsigned")
    assert_equal 2147483647, @driver.max_allowed_value_per_type("int(10)")
    assert_equal 4294967295, @driver.max_allowed_value_per_type("int(10) unsigned")
  end

end
