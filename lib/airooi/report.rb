module Airooi
    class Report

        INFO = "INFO"
        WARN = "WARNING"
        ERROR = "ERROR"

        def initialize()
            @logs = []
        end

        def add(column_name, percentage_used)
            @logs.push({
                :level => level_for(percentage_used),
                :column => column_name,
                :used => percentage_used,
            })
        end

        def logs
            @logs.dup
        end

        def filter(minimum_level)
            @logs.dup.delete_if { |log|
                order(log[:level]) < order(minimum_level)
            }
        end

        private

        def level_for(perc)
          case perc
            when 0...75 then INFO
            when 75...100 then WARN
            when 100 then ERROR
          end
        end

        def order(name)
            case name
                when INFO then 1
                when WARN then 2
                when ERROR then 3
            end
        end
    end
end
