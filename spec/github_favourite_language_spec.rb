require 'github_favourite_language'

describe GitHubFavouriteLanguage do

  let(:username) { 'jamesjoshuahill' }

  def repository(language = 'Ruby', size = 100)
    double :repository, :language => language, :size => size
  end

  def test_output(language, language_name = language)
    expect(subject).to receive(:favourite_language).and_return language
    output = "#{username}'s favourite language on GitHub is #{language_name}."
    expect(STDOUT).to receive(:puts).with(output)
    subject.output(username)
  end

  context 'when given a valid GitHub username' do

    it 'gets their public repositories' do
      expect(subject).to receive(:username).and_return username
      expect(Octokit).to receive(:repositories).with(username).and_return ['repo']
      expect(subject.repositories).to eq ['repo']
    end

    context 'identifies the favourite of' do

      it 'one language' do
        expect(subject).to receive(:repositories).and_return [repository]
        expect(subject.favourite_language).to eq 'Ruby'
      end

      it 'many languages' do
        repositories = [repository('Javascript'), repository, repository, repository('Go')]
        expect(subject).to receive(:repositories).and_return repositories
        expect(subject.favourite_language).to eq 'Ruby'
      end

      context 'two languages' do

        example 'of equal sizes' do
          repositories = [repository('Javascript'), repository]
          expect(subject).to receive(:repositories).and_return repositories
          expect(subject.favourite_language).to eq 'Javascript'
        end

        it 'of different sizes' do
          repositories = [repository('Javascript'), repository('Javascript'), repository('Ruby', 250)]
          expect(subject).to receive(:repositories).and_return repositories
          expect(subject.favourite_language).to eq 'Ruby'
        end
        
      end

    end

    context 'prints the favourite language' do

      example 'Ruby' do
        test_output('Ruby')
      end

      example 'Javascript' do
        test_output('Javascript')
      end

      example 'nil' do
        test_output('nil', 'unknown')
      end

    end

    context 'with no public repositories' do

      it 'prints no public repositories found message' do
        expect(Octokit).to receive(:repositories).with(username).and_return []
        expect(STDOUT).to receive(:puts).with("#{username} has no public repositories.")
        subject.output(username)
      end

    end

  end

  context 'when given an invalid GitHub username' do

    it 'prints user not found message' do
      expect(subject).to receive(:repositories).and_raise Octokit::NotFound
      expect(STDOUT).to receive(:puts).with('Username not found.')
      subject.output(username)
    end

  end

  context 'when too many API requests have been made' do

    it 'prints too many API requests message' do
      expect(subject).to receive(:repositories).and_raise Octokit::TooManyRequests
      expect(STDOUT).to receive(:puts).with('You have run out of GitHub API requests.')
      subject.output(username)
    end

  end

end
