require 'thor'
require 'octokit'
require 'timerizer'

class Fresh < Thor
  package_name "Fresh"
  map "-o" => :older_than

  desc "older_than THRESHOLD", "list repos older than THRESHHOLD"
  def older_than threshold
    print "Login: "
    login = STDIN.gets.chomp

    `stty -echo`
    print "Password: "
    password = STDIN.gets.chomp
    `stty echo`
    puts

    puts "fethcing repos from GitHub..."
    Octokit.auto_paginate = true
    client = Octokit::Client.new login: login, password: password

    old_repos = client.org_repos('neo').select do |r|
      r.updated_at < eval("#{threshold}.ago")
    end

    puts "There are #{old_repos.count} repos that are more than #{threshold} old"
    old_repos.each { |r| puts r.name }
  end

end

Fresh.start
