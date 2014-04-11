module Airooi
  class Table

    def initialize(driver, column)
      @driver = driver
      @column = column
    end

    # Analyze a single table, and return a Report for its numeric fields
    def analyze_table(table_name)
      report = Airooi::Report.new
      @driver.numeric_columns(table_name).each do |column_name|
        perc_used = @column.check_max_value(table_name, column_name)

        report.add(column_name, perc_used)
      end

      return report
    end

    # Analyze all tables, and return a hash of table -> report
    def analyze_database
      reports = {}
      @driver.tables().each do |table_name|
        reports[table_name] = analyze_table(table_name)
      end

      reports
    end
  end
end
