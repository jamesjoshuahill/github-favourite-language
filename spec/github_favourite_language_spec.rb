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

    context 'can identify their favourite language' do

      it 'for one repository' do
        repositories = [repository('Ruby')]
        expect(subject).to receive(:repositories).with(username).and_return repositories
        expect(subject.favourite_language(username)).to eq 'Ruby'
      end

      it 'for three repositories' do
        repositories = [repository('Javascript'), repository('Ruby'), repository('Ruby')]
        expect(subject).to receive(:repositories).with(username).and_return repositories
        expect(subject.favourite_language(username)).to eq 'Ruby'
      end

    end

  end

end
