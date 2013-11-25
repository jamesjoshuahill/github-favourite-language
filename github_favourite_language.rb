#!/usr/bin/env ruby
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
      puts "#{username}'s favourite language on GitHub is #{favourite_language}."
    rescue Octokit::NotFound
      puts "Username not found."
    rescue Octokit::TooManyRequests
      puts "You have run out of GitHub API requests."
    rescue NoPublicRepositories
      puts "#{username} has no public repositories."
    end
  end

  no_commands do

    def favourite_language
      languages = repositories.group_by { |repo| repo.language }
      languages.each do |language, repos|
        languages[language] = repos.map(&:size).inject(:+)
      end
      languages.max_by { |language, size| size }.first
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
