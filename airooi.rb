#!/usr/bin/env ruby

require 'optparse'
require 'mysql2'
require 'io/console'

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

# Parsing the arguments, and printing an error if they are missing
begin
	optparse.parse!
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
	print 'Password: '
	options[:password] = STDIN.noecho(&:gets).gsub("\n", "")
	puts ''
end

# Connecting to the database
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

# Read table list
tables = client.query("SHOW TABLES;")
tables.each do |table|
	puts table[table.keys.first]
end









