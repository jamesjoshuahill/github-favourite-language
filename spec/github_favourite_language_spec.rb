require './github_favourite_language'

describe GitHubFavouriteLanguage do

  let(:username) { 'jamesjoshuahill' }

  def repository(language)
    double :repository, :language => language
  end

  context 'when given a valid GitHub username' do

    it 'can get their repositories' do
      expect(Octokit).to receive(:repositories).with(username).and_return :repo
      expect(subject.repositories(username)).to eq :repo
    end

  end

end
