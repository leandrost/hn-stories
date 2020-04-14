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

    before :each do
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
        stories[0],
        stories[2]
      ]
    end

    context 'when hn api retrieve non story items' do
      let(:stories) do
        [
          Hashie::Mash.new(id: 42,  type: 'story'),
          Hashie::Mash.new(id: 171, type: 'job'),
          Hashie::Mash.new(id: 71,  type: 'show')
        ]
      end

      it 'does not fetches HN items that are not stories' do
        expect(service.call).not_to include(
          have_attributes(id: 171),
          have_attributes(id: 71)
        )
      end
    end

    context 'with too much stories' do
      let(:stories) do
        25.times.map do |id|
          Hashie::Mash.new(id: id, type: 'story', title: 'bar foo')
        end
      end

      it 'fetches stories limited by 15' do
        expect(service.call.size).to eq 15
      end
    end
  end
end
