# frozen_string_literal: true

require 'spec_helper'

describe Devise::JWT do
  it 'has a version number' do
    expect(Devise::JWT::VERSION).not_to be nil
  end
end
