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
      output_favourite
    rescue Octokit::NotFound
      puts "Username not found."
    rescue Octokit::TooManyRequests
      puts "You have run out of GitHub API requests."
    end
  end

  no_commands do

    def output_favourite
      if favourite = favourite_language
        puts "#{username}'s favourite language on GitHub is #{favourite}."
      else
        puts "#{username} has no public repositories."
      end
    end

    def favourite_language
      return nil if repositories.empty?
      languages = repositories.group_by { |repo| repo.language }
      languages.each do |language, repos|
        languages[language] = repos.map(&:size).inject(:+)
      end
      favourite = languages.max_by { |language, size| size }.first
    end

    def repositories
      @repositories ||= Octokit.repositories(username)
    end

  end

end

GitHubFavouriteLanguage.start
