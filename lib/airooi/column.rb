module Airooi
  class Column

    def initialize(driver)
      @driver = driver
    end

    def check_max_value(table_name, column_name)
      max_value = @driver.max_value(table_name, column_name)
      max_allowed_value = @driver.max_allowed_value(table_name, column_name)

      max_value * 100 / max_allowed_value
    end
  end
end
