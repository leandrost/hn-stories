# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stories Routing', type: :routing do
  it 'routes root path to stories' do
    expect(get: '/').to route_to(controller: 'stories', action: 'index')
  end
end
