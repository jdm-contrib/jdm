#!/usr/bin/env ruby

# Validates JSON files in the _data directory

require 'json'

module ExitCodes
    SUCCESS = 0
    PARSE_FAILED = 1           # JSON parse errors
    UNSORTED = 2               # data keys are not in alphanumeric order
    MISSING_URL = 3            # Entry missing the required 'url' field
    MISSING_DIFFICULTY = 4     # Entry missing the required 'difficulty' field
    MISSING_DOMAINS = 5        # Entry missing the required 'domains' field
    MISSING_NAME = 6           # Entry missing the required 'name' field
    UNEXPECTED_DIFFICULTY = 7  # Unexpected value for 'difficulty' field
    UNEXPECTED_LANGUAGE = 8    # Unexpected language code for 'url_code' field
end

SupportedDifficulties = ["easy", "medium", "hard", "impossible"]

def get_supported_languages()
    return translation_files = Dir.children('_data/trans/').map { |f| f.delete_suffix('.json') }
end

SupportedLanguages = get_supported_languages()

def get_transformed_name(site_object)
    return site_object['name'].downcase.sub(/^the\s+/, '')
end

def error_on_missing_field(key, field, exit_code)
    unless key.key?(field)
        STDERR.puts "Entry '#{key['name']}' has no '#{field}' field"
        exit exit_code
    end
end

def validate_difficulty(key)
    difficulty = key['difficulty']
    unless SupportedDifficulties.include?(difficulty)
        STDERR.puts "Entry '#{key['name']}' has unexpected 'difficulty' field:"\
                    "'#{difficulty}'.\n"\
                    "Use one of the supported difficulty values:\n"\
                    "\t#{SupportedDifficulties}"
        exit ExitCodes::UNEXPECTED_DIFFICULTY
    end
end

def validate_localized_urls(key)
    key.keys.each do |entry_key|
        if entry_key.start_with?('url_') && !SupportedLanguages.any? { |lang| entry_key.eql?("url_#{lang}") }
            STDERR.puts "Entry '#{key['name']}' has unrecognized language code: "\
                        "'#{entry_key}'.\n"\
                        "Use one of the supported languages:\n"\
                        "\t#{SupportedLanguages}"
            exit ExitCodes::UNEXPECTED_LANGUAGE
        end
    end
end

def validate_website_entry(key, i)
    unless key.key?('name')
        STDERR.puts "Entry #{i} has no 'name' field"
        exit ExitCodes::MISSING_NAME
    end
    error_on_missing_field(key, 'url', ExitCodes::MISSING_URL)
    error_on_missing_field(key, 'difficulty', ExitCodes::MISSING_DIFFICULTY)
    error_on_missing_field(key, 'domains', ExitCodes::MISSING_DOMAINS)
    validate_difficulty(key)
    validate_localized_urls(key)
end

json_files = Dir.glob('_data/**/*').select { |f| File.file?(f) }
json_files.each do |file|
    begin
        json = JSON.parse(File.read(file))
        is_sites_json = File.basename(file) =~ /sites.json/
        # check for alphabetical ordering
        json.each_with_index do |(key, _), i|
            # sites.json is an array of objects; this would expand to:
            #   key = { ... }
            #   i = 0
            # hence, the key variable holds the actual value
            if is_sites_json
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
                exit ExitCodes::UNSORTED
            end
        end
    rescue JSON::ParserError => error
        STDERR.puts 'JSON parsing error encountered!'
        STDERR.puts error.backtrace.join("\n")
        exit ExitCodes::PARSE_FAILED
    end
end

exit ExitCodes::SUCCESS
