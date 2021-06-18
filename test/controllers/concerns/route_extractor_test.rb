# frozen_string_literal: true

require "test_helper"

class RouteExtractorTest < ActiveSupport::TestCase
  klass = Class.new do
    include Behaveable::RouteExtractor
  end

  test "#resource_name_from singular" do
    params = ActionController::Parameters.new({ controller: "user", id: 1 })
    assert_equal "user", klass.new.send(:resource_name_from, params)
  end

  test "#resource_name_from plural" do
    params = ActionController::Parameters.new({ controller: "user" })
    assert_equal "users", klass.new.send(:resource_name_from, params)
  end

  test "#behaveable_name_from" do
    behaveable = build(:user)
    assert_equal "user", klass.new.send(:behaveable_name_from, behaveable)
    assert_nil klass.new.send(:behaveable_name_from, nil)
  end

  test "#regular without resource" do
    instance = klass.new
    location_url = "somewhere_url"
    resource = nil
    mock(instance).somewhere_url { "/somewhere" }
    assert_equal "/somewhere", instance.send(:regular, location_url, resource)
  end

  test "#regular with resource" do
    instance = klass.new
    location_url = "somewhere_url"
    resource = stub
    mock(instance).somewhere_url(resource) { "/somewhere" }
    assert_equal "/somewhere", instance.send(:regular, location_url, resource)
  end

  test "#nested without resource" do
    instance = klass.new
    location_url = "somewhere_url"
    resource = nil
    behaveable = stub
    mock(instance).somewhere_url(behaveable) { "/somewhere" }
    assert_equal "/somewhere", instance.send(:nested, location_url, behaveable, resource)
  end

  test "#nested with resource" do
    instance = klass.new
    location_url = "somewhere_url"
    resource = stub
    behaveable = stub
    mock(instance).somewhere_url(behaveable, resource) { "/somewhere" }
    assert_equal "/somewhere", instance.send(:nested, location_url, behaveable, resource)
  end
end
