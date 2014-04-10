module Airooi
    class Dao

        @@types = {
          "smallint"  => 32767,
          "mediumint" => 8388607,
          "int"       => 2147483647,
          "bigint"    => 9223372036854775807,
        }

        def initialize(client)
            @client = client
        end

        # Return an array with all table names
        def tables()
            tables = []
            @client.query("SHOW TABLES;").each do |table|
                tables.push(table.values[0])
            end

            tables
        end

        # Return an hash describing the given table
        def numeric_columns(table_name)
            columns = []
            @client.query("DESC `#{table_name}`;").each do |column|
                if is_numeric(column["Type"])
                    columns.push(column["Field"])
                end
            end

            columns
        end

        # Return the maximum value in the specified column
        def max_value(table_name, column_name)
            @client.query("SELECT MAX(#{column_name}) FROM #{table_name};").first.values[0]
        end

        # Return the max allowed value
        def max_allowed_value(type_definition)

            # extract type and sign from the definition
            type = type_definition.match(/^(\w+)/)[0]
            is_signed = type_definition.include? "unsigned"

            # lookup the max allowed value
            max_allowed = @@types[type]
            if is_signed
                max_allowed = (max_allowed * 2) + 1
            end

            max_allowed
        end

        private

        def is_numeric(definition)
            definition.start_with? *@@types.keys
        end
    end
end
