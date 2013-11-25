#!/usr/bin/env ruby
require 'thor'
require 'octokit'

Octokit.auto_paginate = true

class GitHubFavouriteLanguage < Thor
  package_name "GitHub Favourite Language"
  map "-u" => "output"

  desc "-u USERNAME", "Identify the favourite language of a GitHub user"
  def output(username)
    begin
      if favourite = favourite_language(username)
        puts "#{username}'s favourite language on GitHub is #{favourite}."
      else
        puts "#{username} has no public repositories."
      end
    rescue Octokit::NotFound
      puts "Username not found."
    rescue Octokit::TooManyRequests
      puts "You have run out of GitHub API requests."
    end
  end

  no_commands do

    def favourite_language(username)
      repositories = repositories(username)
      return nil if repositories.empty?
      languages = repositories.group_by { |repository| repository.language }
      languages.each do |language, repositories|
        languages[language] = repositories.map(&:size).inject(:+)
      end
      favourite = languages.max_by { |language, size| size }.first
    end

    def repositories(username)
      Octokit.repositories(username)
    end

  end

end

GitHubFavouriteLanguage.start
