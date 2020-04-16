# frozen_string_literal: true

require 'rails_helper'

describe HackerNews::FetchMostRelevantComments do
  describe '#call' do
    subject(:service) { described_class.new(ids: comment_ids) }

    let(:comments) do
      [
        Hashie::Mash.new(id: 1, text: 'nice'),
        Hashie::Mash.new(
          id: 2,
          text: relevant_text
        ),
        Hashie::Mash.new(id: 3, text: 'cool')
      ]
    end

    let(:relevant_text) do
      %(
        Lorem ipsum dolor sit amet, consectetur adipisicing
        elit, sed do eiusmod tempor incididunt ut labore et dolore magna
        aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
        laboris nisi ut aliquip ex ea commodo consequat.
      )
    end

    let(:comment_ids) { comments.map(&:id) }

    before :each do
      comments.each do |item|
        allow(service.client).to receive(:item)
          .with(item.id)
          .and_return(item)
      end
    end

    it 'fetches comments with more than 20 words' do
      expect(service.call).to eq([comments.second])
    end

    context 'with deleted comments' do
      let(:comments) do
        [
          Hashie::Mash.new(id: 1, deleted: true),
          Hashie::Mash.new(
            id: 2,
            text: relevant_text
          ),
          Hashie::Mash.new(id: 3, text: 'cool')
        ]
      end

      it 'ignores deleted comments' do
        expect(service.call).to eq([comments.second])
      end
    end

    context 'with html markup' do
      let(:comments) do
        [
          Hashie::Mash.new(id: 1, deleted: true),
          Hashie::Mash.new(
            id: 2,
            text: relevant_text
          ),
          Hashie::Mash.new(
            id: 3,
            text: %(
            <br><br> <br> <br> <br> <br> <br> <br>
            <br> <br> <br> <br> <br>
            <br> <br> <br> <br> <br> <br> <br> <br>
            <strong> Lorem <strong> <span> ipsum dolor/span>
            )
          )
        ]
      end

      it 'ignores tags inside the text' do
        expect(service.call).to eq([comments.second])
      end
    end
  end
end
