# frozen_string_literal: true

require "test_helper"

class ImagesHelperTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
  include ImagesHelper

  describe "#nested_helper_url" do
    context "without resource" do
      test "should render route helper url" do
        resource_name = "images"
        location_url  = "/images"
        mock(self).location_url(resource_name: resource_name, action: nil, behaveable: nil, resource: nil) do
          location_url
        end
        mock(self).regular(location_url: location_url, resource: nil, format: :html)

        nested_helper_url(resource_name: resource_name, behaveable: nil)
      end
    end

    context "with resource" do
      test "with resource" do
        resource_name = "images"
        location_url  = "/users/42/images"
        resource = nil
        behaveable = stub
        mock(self).location_url(resource_name: resource_name, action: nil, behaveable: behaveable,
                                resource: resource) do
          location_url
        end
        mock(self).nested(location_url: location_url, behaveable: behaveable, resource: resource, format: :html)

        nested_helper_url(resource_name: resource_name, behaveable: behaveable)
      end
    end
  end

  describe "#nested" do
    setup do
      @location_url = "somewhere_url"
    end

    context "without resource" do
      test "should render route helper url" do
        behaveable = stub
        mock(self).somewhere_url(behaveable, format: :html) { "/users/42/images" }
        assert_equal "/users/42/images", send(:nested, location_url: @location_url, behaveable: behaveable)
      end
    end

    context "with resource" do
      test "with resource" do
        resource   = stub
        behaveable = stub
        mock(self).somewhere_url(behaveable, resource, format: :html) { "/users/42/images/24" }

        assert_equal "/users/42/images/24",
                     send(:nested, location_url: @location_url, behaveable: behaveable, resource: resource)
      end
    end
  end

  describe "#regular" do
    setup do
      @location_url = "somewhere_url"
    end

    context "without resource" do
      test "should render route helper url" do
        mock(self).somewhere_url(format: :html) { "/images" }
        assert_equal "/images", send(:regular, location_url: @location_url)
      end
    end

    context "with resource" do
      test "with resource" do
        resource = stub
        mock(self).somewhere_url(resource, format: :html) { "/images/42" }

        assert_equal "/images/42", send(:regular, location_url: @location_url, resource: resource)
      end
    end
  end

  describe "#location_url" do # rubocop:disable Metrics/BlockLength
    context "without resource" do
      test "should return root images url" do
        assert_equal "images_url", send(:location_url, resource_name: "images")
      end

      test "should return nested images url" do
        behaveable = stub
        stub(self).behaveable_name_from(behaveable) { "user" }

        assert_equal "user_images_url", send(:location_url, resource_name: "images", behaveable: behaveable)
      end

      test "should raise an error as edit route need a resource" do
        assert_raises(ImagesHelper::RouteHelperError) do
          send(:location_url, resource_name: "images", action: "edit")
        end
      end

      test "should raise an error as new route need a resource unpersisted" do
        resource = stub
        mock(resource).id { 42 } # persited resource

        assert_raises(ImagesHelper::RouteHelperError) do
          send(:location_url, resource_name: "images", action: "new", resource: resource)
        end
      end

      test "should raise an error as new route need a resource" do
        assert_raises(ImagesHelper::RouteHelperError) do
          send(:location_url, resource_name: "images", action: "new")
        end
      end
    end

    context "with resource" do # rubocop:disable Metrics/BlockLength
      test "should return root image url" do
        resource = stub

        assert_equal "image_url", send(:location_url, resource_name: "images", resource: resource)
      end

      test "should return root edit image url" do
        resource = stub

        assert_equal "edit_image_url", send(:location_url, resource_name: "images", resource: resource, action: "edit")
      end

      test "should return root new image url" do
        resource = stub
        mock(resource).id { nil }

        assert_equal "new_image_url", send(:location_url, resource_name: "images", resource: resource, action: "new")
      end

      test "should return nested image url" do
        behaveable = build(:user)
        resource = stub

        assert_equal "user_image_url",
                     send(:location_url, resource_name: "images", behaveable: behaveable, resource: resource)
      end

      test "should return nested edit image url" do
        behaveable = build(:user)
        resource = stub

        assert_equal "edit_user_image_url",
                     send(:location_url, resource_name: "images", behaveable: behaveable, resource: resource,
                                         action: "edit")
      end

      test "should return nested new image url" do
        behaveable = build(:user)
        resource = stub
        mock(resource).id { nil }

        assert_equal "new_user_image_url",
                     send(:location_url, resource_name: "images", behaveable: behaveable, resource: resource,
                                         action: "new")
      end
    end
  end

  describe "#resource_name_inflection" do
    context "singular" do
      test "should return singular name" do
        resource = stub
        assert_equal "image", send(:resource_name_inflection, resource_name: "images", resource: resource)
      end
    end

    context "plural" do
      test "should return plural name" do
        resource = nil
        assert_equal "images", send(:resource_name_inflection, resource_name: "images", resource: resource)
      end
    end
  end

  test "#behaveable_name_from" do
    behaveable = build(:user)
    assert_equal "user", send(:behaveable_name_from, behaveable)
    assert_nil send(:behaveable_name_from, nil)
  end
end
