require './github_favourite_language'

describe GitHubFavouriteLanguage do

  let(:username) { 'jamesjoshuahill' }

  def repository(language = 'Ruby', size = 100)
    double :repository, :language => language, :size => size
  end

  def test_output(language)
    expect(subject).to receive(:favourite_language).with(username).and_return language
    output = "#{username}'s favourite language on GitHub is #{language}."
    expect(STDOUT).to receive(:puts).with(output)
    subject.output(username)
  end

  context 'when given a valid GitHub username' do

    it 'gets their public repositories' do
      expect(Octokit).to receive(:repositories).with(username).and_return ['repo']
      expect(subject.repositories(username)).to eq ['repo']
    end

    context 'identifies the favourite of' do

      it 'one language' do
        expect(subject).to receive(:repositories).with(username).and_return [repository]
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

    context 'print the favourite language' do

      example 'Ruby' do
        test_output('Ruby')
      end

      example 'Javascript' do
        test_output('Javascript')
      end

    end

    context 'when there are no public repositories' do

      it 'print no public repositories found message' do
        expect(subject).to receive(:repositories).with(username).and_return []
        expect(STDOUT).to receive(:puts).with("#{username} has no public repositories.")
        subject.output(username)
      end

    end

  end

  context 'when given an invalid GitHub username' do

    it 'print user not found message' do
      expect(subject).to receive(:repositories).and_raise Octokit::NotFound
      expect(STDOUT).to receive(:puts).with('Username not found.')
      subject.output(username)
    end

  end

  context 'when too many API requests have been made' do

    it 'print too many API requests message' do
      expect(subject).to receive(:repositories).and_raise Octokit::TooManyRequests
      expect(STDOUT).to receive(:puts).with('You have run out of GitHub API requests.')
      subject.output(username)
    end

  end

end
