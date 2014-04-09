require_relative '../lib/airooi'
require "minitest/autorun"
require 'mysql2'

class TestDao < Minitest::Test

  def setup
    @client = Mysql2::Client.new(
      :host => "localhost",
      :username => "root",
      :password => "",
    )

    @client.query("DROP DATABASE IF EXISTS airooi_test;")
    @client.query("CREATE DATABASE airooi_test;")
    @client.select_db("airooi_test")
    @client.query(File.read File.expand_path("../fixture/test_table_1.sql", __FILE__))
    @client.query(File.read File.expand_path("../fixture/test_table_2.sql", __FILE__))

    @dao = Airooi::Dao.new(@client)
  end

  def test_tables
    tables = @dao.tables()

    assert_equal 2, tables.count
    assert_equal ["article", "user"], tables
  end

  def test_table_info
    info = @dao.table_info("article")

    assert_equal ({
      "id"           => "int",
      "external_id"  => "int unsigned",
      "author_id"    => "mediumint",
      "count"        => "smallint",
      "title"        => "varchar",
      "content"      => "text",
    }), info
  end

  def test_max_value
    @client.query("INSERT INTO article VALUES (100, 200, 300, 2, 'Hello', 'There');")

    assert_equal 100, @dao.max_value("article", "id")
    assert_equal 200, @dao.max_value("article", "external_id")
    assert_equal 300, @dao.max_value("article", "author_id")
    assert_equal 2, @dao.max_value("article", "count")
  end

end
