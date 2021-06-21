# frozen_string_literal: true

require "test_helper"

class PolymorphicImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @image = create(:image)
    @user.images << @image
  end

  describe "#index" do
    context "with an image" do
      context "html" do
        it "should get index" do
          get user_images_url(user_id: @user.id, format: :html)
          assert_response :success
          assert_match @image.name, @response.body
        end
      end

      context "json" do
        it "should get index json" do
          get user_images_url(user_id: @user.id, format: :json)
          assert_response :success
          assert_match %r{^http://www.example.com/users/(\d+)/images}, @response.location
          assert_match @image.name, JSON.parse(@response.body)[0]["name"]
        end
      end
    end
  end

  test "should get new" do
    get new_user_image_url(user_id: @user.id, format: :html)
    assert_response :success
    assert_match %r{^http://www.example.com/users/(\d+)/images/new}, @request.url
  end

  test "should create image" do
    assert_difference -> { @user.images.count } => 1 do
      post user_images_url(user_id: @user.id), params: { image: { name: @image.name } }
    end

    assert_redirected_to user_image_url(user_id: @user.id, id: Image.last.id, format: :html)
  end

  test "should show image" do
    get user_image_url(@user, @image)
    assert_response :success
    assert_match %r{^http://www.example.com/users/(\d+)/images/(\d+)}, @response.location
  end

  test "should get edit" do
    get edit_user_image_url(@user, @image)
    assert_response :success
    assert_match %r{^http://www.example.com/users/(\d+)/images/(\d+)/edit}, @response.location
  end

  test "should update image" do
    patch user_image_url(@user, @image), params: { image: { name: @image.name } }
    assert_redirected_to user_image_url(@user, @image, format: :html)
  end

  test "should destroy image" do
    assert_difference -> { @user.images.count } => -1 do
      delete user_image_url(@user, @image)
    end

    assert_redirected_to user_images_url(@user, format: :html)
  end
end
