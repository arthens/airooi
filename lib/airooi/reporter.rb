module Airooi
    class Reporter

        INFO = "INFO"
        WARN = "WARNING"
        ERROR = "ERROR"

        def initialize()
            @reports = []
        end

        def add(level, message)
            @reports.push({
                :level => level,
                :message => message,
            })
        end

        def reports(minimum_level)
            @reports.dup.delete_if { |report|
                to_index(report[:level]) < to_index(minimum_level)
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
