# frozen_string_literal: true

# Starts the application in production mode and checks that it responds.
#
# RSpec runs in the test environment, so it does not notice what only breaks in
# production (eager loading, static files, the SSL settings and so on). Run this
# in the image built from the top-level Dockerfile:
#
#   docker run --rm <image> ruby script/production_smoke.rb
require "cgi"
require "json"
require "net/http"
require "socket"

ROOT = File.expand_path("..", __dir__)
HOST = "127.0.0.1"
PORT = Integer(ENV.fetch("SMOKE_PORT", "3000"))
LOG = File.join(ROOT, "tmp", "production_smoke.log")
SERVER_ENV = {
  "RAILS_ENV" => "production",
  "ENABLE_GRAPHIQL" => "true",
  # Only for this check. Nothing that leaves the container is signed with it.
  "SECRET_KEY_BASE" => "production_smoke" * 4,
}.freeze
FAILURES = []

def request(method, path, body = nil)
  http = Net::HTTP.new(HOST, PORT)
  http.open_timeout = 5
  http.read_timeout = 30
  # config/environments/production.rb forces SSL, so pretend to be an SSL-terminating proxy.
  req = (method == :post ? Net::HTTP::Post : Net::HTTP::Get).new(path, "X-Forwarded-Proto" => "https")
  if body
    req["Content-Type"] = "application/json"
    req.body = JSON.generate(body)
  end
  http.request(req)
end

def expect_status(res, status)
  raise "expected #{status}, got #{res.code}" unless res.code == status.to_s

  res
end

def graphql(query)
  json = JSON.parse(expect_status(request(:post, "/graphql", query: query), 200).body)
  raise "errors: #{json['errors'].inspect}" if json["errors"]

  json.fetch("data")
end

# The block returns a note to print, or raises when the check fails.
def check(name)
  note = yield
  puts "ok    #{name}#{note.is_a?(String) ? " (#{note})" : ''}"
rescue StandardError => e
  FAILURES << name
  puts "FAIL  #{name}: #{e.message} (#{e.class})"
end

# @return [Boolean] false when the server exited or did not listen within a minute
def wait_for_server(pid)
  120.times do
    return false if Process.waitpid(pid, Process::WNOHANG)

    begin
      TCPSocket.new(HOST, PORT).close
      return true
    rescue SystemCallError
      sleep 0.5
    end
  end
  false
end

def stop(pid)
  Process.kill("TERM", pid)
  Process.waitpid(pid)
rescue Errno::ESRCH, Errno::ECHILD
  # already gone
end

Dir.chdir(ROOT)
pid = Process.spawn(SERVER_ENV, "bundle", "exec", "rails", "server", "-b", HOST, "-p", PORT.to_s,
                    out: LOG, err: [:child, :out])
begin
  if wait_for_server(pid)
    check("GET /up") { expect_status(request(:get, "/up"), 200) }

    check("GET / redirects to /graphiql") do
      location = expect_status(request(:get, "/"), 301)["location"].to_s
      raise "redirected to #{location.inspect}" unless location.end_with?("/graphiql")
    end

    assets = []
    check("GET /graphiql") do
      page = expect_status(request(:get, "/graphiql"), 200).body
      assets = page.scan(%r{(?:href|src)="(/[^"/][^"]*)"}).flatten.map { |path| CGI.unescapeHTML(path) }
      raise "the page has no stylesheet or script" if assets.empty?

      "#{assets.size} assets"
    end

    assets.each do |path|
      check("GET #{path}") do
        body = expect_status(request(:get, path), 200).body.to_s
        raise "empty body" if body.empty?

        "#{body.bytesize} bytes"
      end
    end

    check("POST /graphql { version }") { graphql("{ version }").fetch("version") }

    check("POST /graphql with every type") do
      data = graphql("{ allSeries { seriesName heisei reiwa } allMovies { name } colors { color } precureAll { memberName } }")
      data.map do |field, list|
        raise "#{field} is empty" if list.empty?

        "#{field}: #{list.size}"
      end.join(", ")
    end
  else
    FAILURES << "start"
    puts "FAIL  the server did not start"
  end
ensure
  stop(pid)
end

exit if FAILURES.empty?

# The reason is usually at the top of the log (boot errors) or at its end (request errors).
log = File.readlines(LOG)
log = log.first(30) + ["...\n"] + log.last(60) if log.size > 100
puts "", "--- #{LOG}", log
exit 1
