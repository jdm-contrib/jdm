#!/usr/bin/env ruby

# Validates JSON files in the _data directory
# Exits 0 on success
# Exits 1 upon JSON parsing errors
# Exits 2 if a file's keys are not in alphanumeric order
# Exits 3 if any sites.json entries are missing the required 'url' key
# Exits 4 if any sites.json entries are missing the required 'difficulty' key
# Exits 5 if any sites.json entries are missing the required 'domains' key
# Exits 6 if any sites.json entries are missing the required 'name' key

require 'json'

module ErrorCodes
    SUCCESS = 0
    PARSE_FAILED = 1
    UNSORTED = 2
    MISSING_URL = 3
    MISSING_DIFFICULTY = 4
    MISSING_DOMAINS = 5
    MISSING_NAME = 6
end

def get_transformed_name(site_object)
    return site_object['name'].downcase.sub(/^the\s+/, '')
end

def error_on_missing_field(name, key, field, exit_code)
    unless key.key?(field)
        # Forces all sites.json entries to have the provided key
        STDERR.puts "Entry: #{name} has no #{field}"
        exit exit_code
    end
end

def validate_website_entry(key, i)
    unless key.key?('name')
        # Forces all sites.json entries to have a name
        STDERR.puts "Entry: #{i} has no name"
        exit ErrorCodes::MISSING_NAME
    end
    name = key['name']
    error_on_missing_field(name, key, 'url', ErrorCodes::MISSING_URL)
    error_on_missing_field(name, key, 'difficulty', ErrorCodes::MISSING_DIFFICULTY)
    error_on_missing_field(name, key, 'domains', ErrorCodes::MISSING_DOMAINS)
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
