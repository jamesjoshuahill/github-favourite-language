#!/usr/bin/env ruby
require 'thor'
require 'octokit'

class GitHubFavouriteLanguage < Thor
  package_name "GitHub Favourite Language"

  def repositories(username)
    Octokit.repositories(username)
  end

  def favourite_language(username)
    languages = repositories(username).group_by { |repo| repo.language }
    languages.each { |language, repositories| repositories.map!(&:size) }
    languages.max_by { |language, size| size }.first
  end

end

GitHubFavouriteLanguage.start
