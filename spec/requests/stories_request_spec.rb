# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stories', type: :request do
  describe 'GET /stories' do
    it 'renders successfull response' do
      VCR.use_cassette('top_stories') do
        get '/stories'
      end

      expect(response).to have_http_status(:ok)
    end

    context 'with show comments' do
      it 'renders successfull response' do
        VCR.use_cassette('top_stories_with_show_comments') do
          get '/stories?show_comments=22885621'
        end

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with a search' do
      it 'renders successfull response' do
        VCR.use_cassette('top_stories_with_search') do
          get '/stories?q=covid'
        end

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
