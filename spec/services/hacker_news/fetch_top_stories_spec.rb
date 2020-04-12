# frozen_string_literal: true

require 'rails_helper'

describe HackerNews::FetchTopStories do
  describe '::STORIES_LIMIT' do
    it 'defines top stories count limit to 15 by default' do
      expect(described_class::STORIES_LIMIT).to eq 15
    end
  end

  describe '#call' do
    subject(:service) { described_class.new }

    let(:stories) do
      [
        double(id: 32, type: 'story'),
        double(id: 42, type: 'story'),
        double(id: 24, type: 'story')
      ]
    end

    before :each do
      stub_const('HackerNews::FetchTopStories::STORIES_LIMIT', 2)

      allow(service.client).to receive(:top_stories)
        .and_return(stories.map(&:id))

      stories.each do |item|
        allow(service.client).to receive(:item)
          .with(item.id)
          .and_return(item)
      end
    end

    it 'fetches stories sorted by most recent' do
      expect(service.call).to eq [
        stories[1],
        stories[0]
      ]
    end

    context 'when hn api retrive non story items' do
      let(:stories) do
        [
          double(id: 42,  type: 'story'),
          double(id: 171, type: 'job'),
          double(id: 71,  type: 'show')
        ]
      end

      it 'does not fetches HN items that are not stories' do
        expect(service.call).not_to include(
          have_attributes(id: 171),
          have_attributes(id: 71)
        )
      end
    end
  end
end
