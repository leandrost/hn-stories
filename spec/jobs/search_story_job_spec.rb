require 'rails_helper'

RSpec.describe SearchStoryJob, type: :job do

  describe '.perform_later' do
    subject(:job) { described_class.new }

    let(:story42) { Hashie::Mash.new(id: 42, time: 158_701_131_2) }
    let(:story41) { Hashie::Mash.new(id: 41, time: 158_701_131_2) }

    let(:stream) { 'search:guid' }

    before :each do
      allow(job).to receive(:job_id).and_return('guid')
    end

    it 'broadcasts each search result' do
      allow(ActionCable.server).to receive(:broadcast)
      allow(HackerNews::SearchStories).to receive(:call)
        .and_yield(story42)
        .and_yield(story41)

      job.perform(term: 'marvin')

      expect(ActionCable.server).to have_received(:broadcast).with(
        stream,
        StoryPresenter.new(story42).to_json
      )
      expect(ActionCable.server).to have_received(:broadcast).with(
        stream,
        StoryPresenter.new(story41).to_json
      )
    end
  end
end
