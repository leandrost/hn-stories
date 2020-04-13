# frozen_string_literal: true

require 'rails_helper'

describe ApplicationService do
  describe '.call' do
    subject(:service_class) do
      Class.new(described_class) do
        def initialize(_arg1, _arg2); end
      end
    end

    it 'initializes a new service instance and invoke call method' do
      service_instance = double(call: true)
      argument1 = 'foo'
      argument2 = 'bar'

      allow(service_class).to receive(:new)
        .with(argument1, argument2)
        .and_return(service_instance)

      service_class.call(argument1, argument2)

      expect(service_instance).to have_received(:call)
    end
  end
end
