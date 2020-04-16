# frozen_string_literal: true

require 'rails_helper'

describe HackerNews::SearchStories do
  describe '.call' do
    subject(:service) { described_class.new(term: 'foo') }

    let(:item42) { Hashie::Mash.new(id: 42, type: 'story', title: 'some foo') }
    let(:item43) { Hashie::Mash.new(id: 43, type: 'story', title: 'fooooooo') }
    let(:item44) { Hashie::Mash.new(id: 44, type: 'story', title: 'foo bar') }
    let(:item45) { Hashie::Mash.new(id: 45, type: 'story', title: 'bar foo') }

    let(:items) { [item42, item43, item44, item45] }
    let(:item_ids) { items.map(&:id) }

    before :each do
      allow(service.client).to receive(:get)
        .with('newstories.json')
        .and_return(item_ids)

      fetch_items = allow(HackerNews::FetchItems).to receive(:call)

      items.each do |item|
        fetch_items.and_yield(item)
      end
    end

    it 'fetches stories sorted by most recent' do
      expect(service.call).to eq [item45, item44, item42]
    end

    it 'fetches items limiting by 10' do
      service.call
      expect(HackerNews::FetchItems).to have_received(:call).with(
        ids: item_ids,
        type: 'story',
        limit: 10
      )
    end

    context 'with block' do
      it 'executes given block on each story found' do
        block_stub = double(:block)
        allow(block_stub).to receive(:call)

        service.call do |story|
          block_stub.call(story)
        end

        expect(block_stub).to have_received(:call).with(item45).once
        expect(block_stub).to have_received(:call).with(item44).once
        expect(block_stub).to have_received(:call).with(item42).once
      end
    end

    context 'when not found a term' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'job',   title: 'bar'),
          Hashie::Mash.new(id: 42, type: 'story', title: 'bar')
        ]
      end

      it 'retuns a empty array' do
        expect(service.call).to be_empty
      end
    end
  end
end
