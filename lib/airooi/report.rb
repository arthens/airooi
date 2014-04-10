module Airooi
    class Report

        INFO = "INFO"
        WARN = "WARNING"
        ERROR = "ERROR"

        def initialize()
            @logs = []
        end

        def add(level, message)
            @logs.push({
                :level => level,
                :message => message,
            })
        end

        def logs
            @logs.dup
        end

        def filter(minimum_level)
            @logs.dup.delete_if { |log|
                to_index(log[:level]) < to_index(minimum_level)
            }
        end

        private

        def to_index(name)
            case name
                when INFO then 1
                when WARN then 2
                when ERROR then 3
            end
        end
    end
end
