# frozen_string_literal: true

require "rails_helper"

describe ListTopStories do
  describe '.call' do
    subject(:service) { described_class.new }

    let(:stories) do
      [
        Hashie::Mash.new(id: 42),
        Hashie::Mash.new(id: 24)
      ]
    end

    before :each do
      allow(HackerNews::FetchTopStories).to receive(:call)
        .and_return(stories)
    end

    it 'fetches top stories' do
      service.call
      expect(HackerNews::FetchTopStories).to have_received(:call)
    end

    it 'returns stories presenters' do
      expect(service.call).to be_all(StoryPresenter)
      expect(service.call).to contain_exactly(
        have_attributes(id: 42),
        have_attributes(id: 24)
      )
    end

    context 'with comment_for' do
      subject(:service) { described_class.new(comment_for: '42') }

      let(:story41) { Hashie::Mash.new(id: 41, kids: [1, 2]) }
      let(:story42) { Hashie::Mash.new(id: 42, kids: [3, 4]) }

      let(:stories) { [story42, story41] }
      let(:comments) do
        [
          Hashie::Mash.new(id: 3, type: 'comment'),
          Hashie::Mash.new(id: 4, type: 'comment')
        ]
      end

      before :each do
        allow(HackerNews::FetchMostRelevantComments).to receive(:call)
          .and_return(comments)
      end

      it 'fetches most relevant commets' do
        service.call

        expect(HackerNews::FetchMostRelevantComments).to have_received(:call)
          .with(ids: story42.kids)
      end

      it 'loads most relevant comments for given stroy id' do
        expect(service.call).to include(
          have_attributes(id: 42, most_relevant_comments: comments)
        )
      end
    end
  end
end
