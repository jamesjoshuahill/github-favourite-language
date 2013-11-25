require './github_favourite_language'

describe GitHubFavouriteLanguage do

  let(:username) { 'jamesjoshuahill' }

  def repository(language = 'Ruby', size = 100)
    double :repository, :language => language, :size => size
  end

  context 'when given a valid GitHub username' do

    it 'can get their repositories' do
      expect(Octokit).to receive(:repositories).with(username).and_return :repo
      expect(subject.repositories(username)).to eq :repo
    end

    context 'can identify their favourite of' do

      it 'one language' do
        repositories = [repository]
        expect(subject).to receive(:repositories).with(username).and_return repositories
        expect(subject.favourite_language(username)).to eq 'Ruby'
      end

      it 'many languages' do
        repositories = [repository('Javascript'), repository, repository, repository('Go')]
        expect(subject).to receive(:repositories).with(username).and_return repositories
        expect(subject.favourite_language(username)).to eq 'Ruby'
      end

      context 'two languages' do

        example 'of equal sizes' do
          repositories = [repository('Javascript'), repository]
          expect(subject).to receive(:repositories).with(username).and_return repositories
          expect(subject.favourite_language(username)).to eq 'Javascript'
        end

        it 'of different sizes' do
          repositories = [repository('Javascript'), repository('Javascript'), repository('Ruby', 250)]
          expect(subject).to receive(:repositories).with(username).and_return repositories
          expect(subject.favourite_language(username)).to eq 'Ruby'
        end
        
      end

    end

  end

end
