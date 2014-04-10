module Airooi
  class Table

    def initialize(dao, column)
      @dao = dao
      @column = column
    end

    # Analyze a single table, and return a Report for its numeric fields
    def analyze_table(table_name)
      report = Airooi::Report.new
      @dao.numeric_columns(table_name).each do |column_name|
        result = @column.check_max_value(table_name, column_name)

        report.add(result[0], result[1])
      end

      return report
    end

    # Analyze all tables, and return a hash of table -> report
    def analyze_database
      reports = {}
      @dao.tables().each do |table_name|
        reports[table_name] = analyze_table(table_name)
      end

      reports
    end
  end
end
