# frozen_string_literal: true

require "test_helper"

class RouteExtractorTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
  RouteExtractorKlass = Class.new do
    include Behaveable::RouteExtractor
  end

  setup do
    @instance = RouteExtractorKlass.new
  end

  describe "#location_url" do # rubocop:disable Metrics/BlockLength
    context "resources" do
      setup do
        @params = ActionController::Parameters.new({ controller: "image" })
      end

      test "should return root images url" do
        stub(@instance).params { @params }
        behaveable = nil

        assert_equal "images_url", @instance.send(:location_url, behaveable: behaveable)
      end

      test "should return nested images url" do
        stub(@instance).params { @params }
        behaveable = stub
        stub(@instance).behaveable_name_from(behaveable) { "user" }

        assert_equal "user_images_url", @instance.send(:location_url, behaveable: behaveable)
      end
    end

    context "resource" do
      setup do
        @params = ActionController::Parameters.new({ controller: "image", id: 42 })
      end

      test "should return root image url" do
        stub(@instance).params { @params }
        behaveable = nil
        resource = stub

        assert_equal "image_url", @instance.send(:location_url, behaveable: behaveable, resource: resource)
      end

      test "should return nested image url" do
        stub(@instance).params { @params }
        behaveable = stub
        stub(@instance).behaveable_name_from(behaveable) { "user" }

        assert_equal "user_images_url", @instance.send(:location_url, behaveable: behaveable)
      end
    end
  end

  describe "#regular" do # rubocop:disable Metrics/BlockLength
    setup do
      @location_url = "somewhere_url"
    end

    context "without resource" do
      test "should execute route helper images_url" do
        resource = nil
        mock(@instance).somewhere_url(format: :html) { "/images" }

        assert_equal "/images", @instance.send(:regular, location_url: @location_url, resource: resource)

        behaveable = nil
        params = ActionController::Parameters.new({ controller: "image" })
        stub(@instance).params { params }
        mock(@instance).regular(location_url: "images_url", resource: resource, format: :html) { "/images" }

        assert_equal "/images", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end

    context "with resource" do
      test "with resource" do
        resource = stub
        mock(resource).id { 42 }
        mock(@instance).somewhere_url(resource, format: :html) { "/images/42" }

        assert_equal "/images/42", @instance.send(:regular, location_url: @location_url, resource: resource)

        behaveable = nil
        params = ActionController::Parameters.new({ controller: "image", id: 42 })
        stub(@instance).params { params }
        mock(@instance).regular(location_url: "image_url", resource: resource, format: :html) { "/images/42" }

        assert_equal "/images/42", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end
  end

  describe "#resource_name_from" do
    context "singular" do
      setup do
        @params = ActionController::Parameters.new({ controller: "image", id: 1 })
      end

      test "should return singular name" do
        stub(@instance).params { @params }
        resource = stub
        assert_equal "image", @instance.send(:resource_name_from, resource)
      end
    end

    context "plural" do
      setup do
        @params = ActionController::Parameters.new({ controller: "image" })
      end

      test "should return plural name" do
        stub(@instance).params { @params }
        resource = nil
        assert_equal "images", @instance.send(:resource_name_from, resource)
      end
    end
  end

  test "#behaveable_name_from" do
    behaveable = build(:image)
    assert_equal "image", RouteExtractorKlass.new.send(:behaveable_name_from, behaveable)
    assert_nil RouteExtractorKlass.new.send(:behaveable_name_from, nil)
  end

  describe "#nested" do # rubocop:disable Metrics/BlockLength
    setup do
      @location_url = "nested_somewhere_url"
    end

    context "without resource" do
      test "should execute route helper images_url" do
        resource = nil
        behaveable = User.new
        mock(@instance).nested_somewhere_url(behaveable, format: :html) { "/users/24/images" }

        assert_equal "/users/24/images",
                     @instance.send(:nested, location_url: @location_url, behaveable: behaveable, resource: resource)

        params = ActionController::Parameters.new({ controller: "image" })
        stub(@instance).params { params }
        mock(@instance).nested(location_url: "user_images_url", behaveable: behaveable, resource: resource,
                               format: :html) do
          "/users/24/images"
        end

        assert_equal "/users/24/images", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end

    context "with resource" do
      test "with resource" do
        resource = stub
        mock(resource).id { 42 }
        behaveable = User.new
        mock(@instance).nested_somewhere_url(behaveable, resource, format: :html) { "/users/24/images/42" }

        assert_equal "/users/24/images/42",
                     @instance.send(:nested, location_url: @location_url, behaveable: behaveable, resource: resource)

        params = ActionController::Parameters.new({ controller: "image", id: 42 })
        stub(@instance).params { params }
        mock(@instance).nested(location_url: "user_image_url", behaveable: behaveable, resource: resource,
                               format: :html) do
          "/users/24/images/42"
        end

        assert_equal "/users/24/images/42", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end
  end
end
