# frozen_string_literal: true

require 'rails_helper'

describe HackerNews::FetchTopStories do
  describe '#call' do
    subject(:service) { described_class.new }

    let(:stories) do
      [
        Hashie::Mash.new(id: 32, type: 'story'),
        Hashie::Mash.new(id: 42, type: 'story'),
        Hashie::Mash.new(id: 24, type: 'story')
      ]
    end

    let(:stories_ids) { stories.map(&:id) }

    before :each do
      allow(service.client).to receive(:top_stories)
        .and_return(stories_ids)

      allow(HackerNews::FetchItems).to receive(:call)
        .and_return(stories)
    end

    it 'fetches stories sorted by most recent' do
      expect(service.call).to eq [
        stories[1],
        stories[0],
        stories[2]
      ]
    end

    it 'fetches stories limited by 15' do
      service.call
      expect(HackerNews::FetchItems).to have_received(:call)
        .with(ids: stories_ids, type: 'story', limit: 15)
    end
  end
end
