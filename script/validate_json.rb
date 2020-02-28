#!/usr/bin/env ruby

# Validates JSON files in the _data directory
# Exits 0 on success
# Exits 1 upon JSON parsing errors
# Exits 2 if a file's keys are not in alphanumeric order
# Exits 3 if any sites.json entries are missing the required 'url' key

require 'json'

def get_transformed_name(site_object)
    return site_object['name'].downcase.sub(/^the\s+/, '')
end

def error_on_missing_field(key, field, exit_code)
    name = get_transformed_name(key)
    unless key.key?(field)
        # Forces all sites.json entries to have the provided key
        STDERR.puts "Entry: #{name} has no #{field}"
        exit exit_code
    end
end

json_files = Dir.glob('_data/**/*').select { |f| File.file?(f) }
json_files.each do |file|
    begin
        json = JSON.parse(File.read(file))
        # check for alphabetical ordering
        json.each_with_index do |(key, _), i|
            next if i.zero?

            # sites.json is an array of objects; this would expand to:
            #   key = { ... }
            #   i = 0
            # hence, the key variable holds the actual value
            if File.basename(file) =~ /sites.json/
                name = get_transformed_name(key)
                prev_name = get_transformed_name(json[i - 1])
                error_on_missing_field(key, 'url', 3)
            else
                name = key
                prev_name = json.keys[i - 1]
            end
            if prev_name > name
                STDERR.puts 'Sorting error in ' + file
                STDERR.puts 'Keys must be in alphanumeric order. ' + \
                            prev_name + ' needs to come after ' + name
                exit 2
            end
        end
    rescue JSON::ParserError => error
        STDERR.puts 'JSON parsing error encountered!'
        STDERR.puts error.backtrace.join("\n")
        exit 1
    end
end

exit 0
