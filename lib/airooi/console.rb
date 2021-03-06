require 'optparse'
require 'mysql2'
require 'io/console'
require 'colorize'

module Airooi
  class Console

    def execute(params)

      options = parse(params)
      client = connect(options)
      driver = Airooi::Driver::Mysql.new(client)
      column = Airooi::Column.new(driver)
      table = Airooi::Table.new(driver, column)

      reports = table.analyze_database()

      if options[:verbose]
        print_reports(reports, Airooi::Report::INFO)
      else
        print_reports(reports, Airooi::Report::WARN)
      end
    end

    def connect(options)
      begin
        client = Mysql2::Client.new(
          :host => options[:host],
          :username => options[:user],
          :password => options[:password],
        )
        client.select_db(options[:database])
      rescue Mysql2::Error => e
        puts "Connection to the database failed: " + e.message
        exit
      end

      client
    end

    def print_reports(reports, minimum_level)
      reports.keys.each do |table_name|

        table_report = reports[table_name].filter(minimum_level)
        puts "== %s == " % [table_name] unless table_report.empty?

        table_report.each do |log|
          color = case log[:level]
            when Airooi::Report::INFO then :green
            when Airooi::Report::WARN then :yellow
            when Airooi::Report::ERROR then :red
          end

          puts "[%d%%] %s".colorize(color) % [log[:used], log[:column]]
        end
      end
    end

    def parse(params)
      # Argument definitions
      options = {}
      optparse = ::OptionParser.new do |opts|
        opts.banner = 'Usage: airooi.rb'

        options[:verbose] = false
        opts.on('-v', '--verbose', 'Print detailed view') do
          options[:verbose] = true
        end

        # Connection params
        options[:host] = "localhost"
        opts.on('-h', '--host=host', 'Database hostname - default to localhost') do |host|
          options[:host] = host
        end

        opts.on('-u', '--user=user', 'Database user') do |user|
          options[:user] = user
        end

        opts.on('-p', '--password=password', 'Database password') do |pass|
          options[:pass] = pass
        end

        opts.on('-d', '--database=database', 'Name of the database') do |database|
          options[:database] = database
        end
      end

      begin
        optparse.parse! params
        mandatory = [:host, :user, :database]
        missing = mandatory.select{ |param| options[param].nil? }
        if not missing.empty?
          puts "Missing options: #{missing.join(', ')}"
          puts optparse
          exit
        end
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
        puts $!.to_s
        puts optparse
        exit
      end

      # Ask for a password if it wasn't provided when invoking the script
      if not options.has_key?('password')
        begin
          print 'Password: '
          options[:password] = STDIN.noecho(&:gets).gsub("\n", "")
          puts ''
        rescue Interrupt
          puts ''
          exit
        end
      end

      options
    end
  end
end
