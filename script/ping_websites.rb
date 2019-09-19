#!/usr/bin/env ruby

# Validates sites.json in the _data directory
# Exits 0 on success, exits 1 upon JSON parsing errors

require "net/http"
require "json"

# thread pool class
class ThreadPool
    def initialize(size)
        @size = size
        @jobs = Queue.new
        @pool = Array.new(@size) do |i|
            Thread.new do
                Thread.current[:id] = i
                catch(:exit) do
                    loop do
                        job, args = @jobs.pop
                        job.call(*args)
                    end
                end
            end
        end
    end

    # add a job to queue
    def schedule(*args, &block)
        @jobs << [block, args]
    end

    # run threads and perform jobs from queue
    def run!
        @size.times do
            schedule { throw :exit }
        end
        @pool.map(&:join)
    end
end

def url_exist(name, url_string)
    url = URI.parse(url_string.strip)
    res = Net::HTTP.get_response(url)
    if res.kind_of?(Net::HTTPRedirection)
        # Do nothing
    elsif res.code == "404"
        # Some webpages return 404 even though they properly redirect to login pages
        STDERR.puts "Entry: #{name} returned #{res.to_s}"
    end
rescue  Errno::ECONNRESET,
        Errno::EHOSTUNREACH,
        Errno::ENOENT,
        Errno::ETIMEDOUT,
        Net::OpenTimeout,
        Net::ReadTimeout,
        SocketError => e
    # All categories where a site is most definitely not operational anymore
    puts "Rescued #{name}: #{e.inspect}"
    false
rescue OpenSSL::SSL::SSLError
    # Bad website has SSL certificate error, but at least it responds to requests
    true
end

begin
    json = JSON.parse(File.read('_data/sites.json'))
    pool = ThreadPool.new(20)
    # check if a website is alive
    json.each_with_index do |(key, _), i|
        name = key['name']
        if key.key?('url')
            url = key['url']
            pool.schedule(name, url) do |name , url|
                url_exist(name, url)
            end
        else
            # Forces all entries on the JSON to have an URL
            STDERR.puts "Entry: #{name} has no URL"
            exit 1
        end
    end
    pool.run!
rescue JSON::ParserError => error
    STDERR.puts 'JSON parsing error encountered!'
    STDERR.puts error.backtrace.join("\n")
    exit 1
end

exit 0
