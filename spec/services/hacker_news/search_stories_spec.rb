# frozen_string_literal: true

require 'rails_helper'

describe HackerNews::SearchStories do
  describe '.call' do
    subject(:service) { described_class.new(term: 'foo') }

    let(:item42) { Hashie::Mash.new(id: 42, type: 'story', title: 'some foo') }
    let(:item43) { Hashie::Mash.new(id: 41, type: 'story', title: 'fooooooo') }
    let(:item44) { Hashie::Mash.new(id: 43, type: 'story', title: 'foo bar') }
    let(:item45) { Hashie::Mash.new(id: 44, type: 'story', title: 'bar foo') }

    let(:items) { [item42, item43, item44, item45] }

    before :each do
      max_item_id = items.map(&:id).max

      allow(service.client).to receive(:max_item).and_return(max_item_id)
      allow(service.client).to receive(:item)

      items.each do |item|
        allow(service.client).to receive(:item)
          .with(item.id)
          .and_return(item)
      end
    end

    it 'fetches stories sorted by most recent' do
      expect(service.call).to eq [item45, item44, item42]
    end

    context 'with too much stories' do
      let(:items) do
        15.times.map do |id|
          Hashie::Mash.new(id: id, type: 'story', title: 'bar foo')
        end
      end

      it 'fetches stories limited by 10' do
        expect(service.call.size).to eq 10
      end
    end

    context 'when not found a term' do
      skip 'TODO'
    end

    context 'when hn api retrieve non story items' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'job',   title: 'foo'),
          Hashie::Mash.new(id: 42, type: 'story', title: 'foo'),
          Hashie::Mash.new(id: 23, type: 'show',  title: 'foo')
        ]
      end

      it 'fetches only story items' do
        expect(service.call).to contain_exactly(
          have_attributes(id: 42)
        )
      end
    end

    context 'when hn api retrieve `dead` items' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'story', dead: 'foo'),
          Hashie::Mash.new(id: 42, type: 'story', title: 'foo')
        ]
      end

      it 'fetches only non `dead` items' do
        expect(service.call).to contain_exactly(
          have_attributes(id: 42)
        )
      end
    end

    context 'when hn api retrieve `deleted` items' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'story', deleted: true),
          Hashie::Mash.new(id: 42, type: 'story', title: 'foo')
        ]
      end

      it 'fetches only non `deleted` items' do
        expect(service.call).to contain_exactly(
          have_attributes(id: 42)
        )
      end
    end
  end
end
