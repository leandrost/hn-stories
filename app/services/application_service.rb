# frozen_string_literal: true

class ApplicationService
  def self.call(*args, &block)
    instance = new(*args)
    return instance.call(&block) if block_given?

    instance.call
  end
end
