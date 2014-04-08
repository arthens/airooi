module Airooi
    class Reporter

        INFO = 1
        WARN = 2
        ERROR = 3

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
            @reports.dup.delete_if { |report| report[:level] < minimum_level }
        end
    end
end
