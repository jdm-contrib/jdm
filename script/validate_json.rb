#!/usr/bin/env ruby

# Validates JSON files in the _data directory
# See ErrorCodes for actual return value
# Exits 'SUCCESS' on success
# Exits 'PARSE_FAILED' upon JSON parsing errors
# Exits 'UNSORTED' if a file's keys are not in alphanumeric order
# Exits 'MISSING_URL' if any sites.json entries are missing the required 'url' key
# Exits 'MISSING_DIFFICULTY' if any sites.json entries are missing the required 'difficulty' key
# Exits 'MISSING_DOMAINS' if any sites.json entries are missing the required 'domains' key
# Exits 'MISSING_NAME' if any sites.json entries are missing the required 'name' key
# Exits 'UNEXPECTED_DIFFICULTY' if field contains unexpected value on 'difficulty' key

require 'json'

module ErrorCodes
    SUCCESS = 0
    PARSE_FAILED = 1
    UNSORTED = 2
    MISSING_URL = 3
    MISSING_DIFFICULTY = 4
    MISSING_DOMAINS = 5
    MISSING_NAME = 6
    UNEXPECTED_DIFFICULTY = 7
end

def get_transformed_name(site_object)
    return site_object['name'].downcase.sub(/^the\s+/, '')
end

def error_on_missing_field(name, key, field, exit_code)
    unless key.key?(field)
        STDERR.puts "Entry: #{name} has no #{field}"
        exit exit_code
    end
end

def validate_website_entry(key, i)
    unless key.key?('name')
        STDERR.puts "Entry: #{i} has no name"
        exit ErrorCodes::MISSING_NAME
    end
    name = key['name']
    error_on_missing_field(name, key, 'url', ErrorCodes::MISSING_URL)
    error_on_missing_field(name, key, 'difficulty', ErrorCodes::MISSING_DIFFICULTY)
    error_on_missing_field(name, key, 'domains', ErrorCodes::MISSING_DOMAINS)
    difficulty = key['difficulty']
    supported_difficulties = ["easy","medium","hard","impossible"]
    unless supported_difficulties.include?(difficulty)
        STDERR.puts "Entry: #{name} has unexpected difficulty: #{difficulty}. Use one of #{supported_difficulties}"
        exit ErrorCodes::UNEXPECTED_DIFFICULTY
    end
end

json_files = Dir.glob('_data/**/*').select { |f| File.file?(f) }
json_files.each do |file|
    begin
        json = JSON.parse(File.read(file))
        # check for alphabetical ordering
        json.each_with_index do |(key, _), i|
            # sites.json is an array of objects; this would expand to:
            #   key = { ... }
            #   i = 0
            # hence, the key variable holds the actual value
            if File.basename(file) =~ /sites.json/
                validate_website_entry(key, i)
                name = get_transformed_name(key)
                prev_name = get_transformed_name(json[i - 1])
            else
                name = key
                prev_name = json.keys[i - 1]
            end
            if i > 0 && prev_name > name
                STDERR.puts 'Sorting error in ' + file
                STDERR.puts 'Keys must be in alphanumeric order. ' + \
                            prev_name + ' needs to come after ' + name
                exit ErrorCodes::UNSORTED
            end
        end
    rescue JSON::ParserError => error
        STDERR.puts 'JSON parsing error encountered!'
        STDERR.puts error.backtrace.join("\n")
        exit ErrorCodes::PARSE_FAILED
    end
end

exit ErrorCodes::SUCCESS
