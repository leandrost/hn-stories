# frozen_string_literal: true

require 'rails_helper'

describe HackerNews::FetchItems do
  describe '.call' do
    subject(:service) do
      described_class.new(
        ids: items.map(&:id),
        type: 'show'
      )
    end

    let(:item42) { Hashie::Mash.new(id: 42, type: 'show', title: 'some foo') }
    let(:item43) { Hashie::Mash.new(id: 43, type: 'show', title: 'fooooooo') }
    let(:item44) { Hashie::Mash.new(id: 44, type: 'show', title: 'foo bar') }
    let(:item45) { Hashie::Mash.new(id: 45, type: 'show', title: 'bar foo') }

    let(:items) { [item42, item43, item44, item45] }

    before :each do
      allow(service.client).to receive(:item)

      items.each do |item|
        allow(service.client).to receive(:item)
          .with(item.id)
          .and_return(item)
      end
    end

    it 'returns items' do
      expect(service.call).to eq items
    end

    context 'with block' do
      it 'executes given block on each item found' do
        block_stub = double(:block)
        allow(block_stub).to receive(:call)

        service.call do |item|
          block_stub.call(item)
        end

        expect(block_stub).to have_received(:call).with(item45).once
        expect(block_stub).to have_received(:call).with(item44).once
        expect(block_stub).to have_received(:call).with(item42).once
      end
    end

    context 'with limit' do
      subject(:service) do
        described_class.new(
          ids: items.map(&:id),
          type: 'show',
          limit: limit
        )
      end

      let(:limit) { 25 }

      let(:items) do
        50.times.map do |id|
          Hashie::Mash.new(id: id, type: 'show', title: 'bar foo')
        end
      end

      it 'fetches items by the given limit' do
        expect(service.call.size).to eq limit
      end
    end

    context 'when api retreive many types' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'job',  title: 'foo'),
          Hashie::Mash.new(id: 42, type: 'show', title: 'foo'),
          Hashie::Mash.new(id: 23, type: 'pool', title: 'foo')
        ]
      end

      it 'fetches only items from the given type' do
        expect(service.call).to contain_exactly(
          have_attributes(id: 42)
        )
      end
    end

    context 'when api retreive `dead` items' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'show', dead: 'foo'),
          Hashie::Mash.new(id: 42, type: 'show', title: 'foo')
        ]
      end

      it 'fetches only non `dead` items' do
        expect(service.call).to contain_exactly(
          have_attributes(id: 42)
        )
      end
    end

    context 'when api retreive `deleted` items' do
      let(:items) do
        [
          Hashie::Mash.new(id: 13, type: 'show', deleted: true),
          Hashie::Mash.new(id: 42, type: 'show', title: 'foo')
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
