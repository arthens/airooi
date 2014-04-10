module Airooi
  class ColumnAnalyzer

    ERROR_LEVEL = 100
    WARN_LEVEL = 75

    def initialize(dao)
      @dao = dao
    end

    def check_max_value(table_name, column_name)
      definition = @dao.column_info(table_name, column_name)
      max_value = @dao.max_value(table_name, column_name)
      max_allowed_value = @dao.max_allowed_value(definition)
      perc_used = max_value * 100 / max_allowed_value

      level = level_for(perc_used)
      message = "%s.%s is %d%% full" % [table_name, column_name, perc_used]

      [level, message]
    end

    def level_for(perc)
      case perc
        when 0...75 then Airooi::Reporter::INFO
        when 75...100 then Airooi::Reporter::WARN
        when 100 then Airooi::Reporter::ERROR
      end
    end

  end
end
