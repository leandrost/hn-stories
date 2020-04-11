# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stories', type: :request do
  describe 'GET /stories' do
    it 'renders successfull response' do
      get '/stories'
      expect(response).to have_http_status(:ok)
    end
  end
end
