# frozen_string_literal: true
require 'rails_helper'

describe StoryPresenter, type: :presenter do
  subject(:presenter) { described_class.new(object) }

  let(:object) { Hashie::Mash.new }

  describe '#most_relevant_comments' do
    it 'is empty array by default' do
      object.most_relevant_comments = nil
      expect(presenter.most_relevant_comments).to eq []
    end
  end

  describe '#comments_count' do
    it 'is kids size' do
      object.kids = [42, 24]
      expect(presenter.comments_count).to eq '2 comments'
    end

    context 'when kids blank' do
      it 'is zero' do
        object.kids = nil
        expect(presenter.comments_count).to eq '0 comments'
      end
    end
  end

  describe '#time' do
    it 'is object time formatted' do
      object.time = 158_700_559_7
      expect(presenter.time).to eq 'Wed, 15 Apr 2020 23:53:17 -0300'
    end
  end

  describe '#comments_url' do
    it 'is a url to fetch comments' do
      object.id = 42
      expect(presenter.comments_url).to eq '/stories?show_comments=42'
    end
  end

  describe '#to_json' do
    it 'serializes to json' do
      object.id = 42
      object.time = 158_700_559_7

      expect(presenter.to_json).to eq({
        id: 42,
        time: 'Wed, 15 Apr 2020 23:53:17 -0300',
        comments_url: presenter.comments_url,
        most_relevant_comments: [],
        comments_count: '0 comments'
      }.to_json)
    end
  end
end
