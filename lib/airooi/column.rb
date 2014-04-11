module Airooi
  class Column

    def initialize(dao)
      @dao = dao
    end

    def check_max_value(table_name, column_name)
      max_value = @dao.max_value(table_name, column_name)
      max_allowed_value = @dao.max_allowed_value(table_name, column_name)

      max_value * 100 / max_allowed_value
    end
  end
end
