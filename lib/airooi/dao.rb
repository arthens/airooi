module Airooi
    class Dao

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
        def table_info(table_name)
            columns = {}
            @client.query("DESC `#{table_name}`;").each do |column|
                name = column["Field"]
                type = column["Type"].match(/^(\w+)/)[0]
                if column["Type"].include? "unsigned"
                    type = type + " unsigned"
                end

                columns[name] = type
            end

            columns
        end

        # Return the maximum value in the specified column
        def max_value(table_name, column_name)
            @client.query("SELECT MAX(#{column_name}) FROM #{table_name};").first.values[0]
        end
    end
end
