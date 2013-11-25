require 'thor'
require 'octokit'

Octokit.auto_paginate = true

class GitHubFavouriteLanguage < Thor
  attr_reader :username

  package_name "GitHub Favourite Language"
  map "-u" => "output"

  desc "-u USERNAME", "Identify the favourite language of a GitHub user"
  def output(argument)
    @username = argument
    begin
      puts "#{username}'s favourite language on GitHub is #{favourite}."
    rescue Octokit::NotFound
      puts "Username not found."
    rescue Octokit::TooManyRequests
      puts "You have run out of GitHub API requests."
    rescue NoPublicRepositories
      puts "#{username} has no public repositories."
    end
  end

  no_commands do

    def favourite
      f = favourite_language
      f == 'nil' ? 'unknown' : f
    end

    def favourite_language
      repositories.inject(Hash.new(0)) do |languages, repository|
        languages[repository.language] += repository.size
        languages
      end.max_by { |language, total_size| total_size }.first
    end

    def repositories
      response = Octokit.repositories(username)
      raise NoPublicRepositories if response.empty?
      @repositories ||= response
    end

  end

end

class NoPublicRepositories < StandardError; end

GitHubFavouriteLanguage.start
