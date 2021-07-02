# frozen_string_literal: true

require "test_helper"

class ResourceFinderTest < ActiveSupport::TestCase
  klass = Class.new do
    include Behaveable::ResourceFinder
    def initialize(params) # rubocop:disable Lint/MissingSuper
      @params = params
    end
    attr_reader :params
  end

  test "#behaveable_class" do
    params = ActionController::Parameters.new({ user_id: "1" })
    instance = klass.new(params)
    model_klass, param = instance.send(:behaveable_class)
    assert_equal User, model_klass
    assert_equal "user_id", param
  end

  test "#behaveable" do
    user = create(:user)
    params = ActionController::Parameters.new({ user_id: user.id })
    permitted = params.permit(:user_id)
    instance = klass.new(permitted)
    assert_equal user, instance.behaveable
  end
end
