# frozen_string_literal: true

require "test_helper"

class ImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @image = create(:image)
  end

  describe "#index" do # rubocop:disable Metrics/BlockLength
    context "with an image" do # rubocop:disable Metrics/BlockLength
      context "html" do
        it "should get index" do
          get images_url
          assert_response :success
          assert_match @image.name, @response.body
        end
      end

      context "json" do
        it "should get index json" do
          get images_url(format: :json)
          assert_response :success
          assert_match %r{^http://www.example.com/images}, @response.location
          assert_match @image.name, JSON.parse(@response.body)[0]["name"]
        end
      end

      context "with a behaveable" do
        setup do
          @user = create(:user)
          @user.images << @image
        end

        context "json" do
          it "should get index json" do
            get images_url(user_id: @user.id, format: :json)
            assert_response :success
            assert_match %r{^http://www.example.com/users/(\d+)/images}, @response.location
            assert_match @image.name, JSON.parse(@response.body)[0]["name"]
          end
        end
      end
    end
  end

  test "should get index" do
    get images_url
    assert_response :success
    assert_match @image.name, @response.body
  end

  test "should get index json" do
    get images_url(format: :json)
    assert_response :success
    assert_match @image.name, JSON.parse(@response.body)[0]["name"]
  end

  test "should get new" do
    get new_image_url
    assert_response :success
  end

  test "should create image" do
    assert_difference("Image.count") do
      post images_url,
           params: { image: { name: @image.name,
                              attachment: fixture_file_upload("test/fixtures/favicon.ico",
                                                              "image/vnd.microsoft.icon") } }
    end

    assert_redirected_to image_url(Image.last)
    assert_equal "favicon.ico", Image.last.attachment.filename.to_s
  end

  test "should show image" do
    get image_url(@image)
    assert_response :success
  end

  test "should get edit" do
    get edit_image_url(@image)
    assert_response :success
  end

  test "should update image" do
    patch image_url(@image), params: { image: { name: @image.name } }
    assert_redirected_to image_url(@image)
  end

  test "should destroy image" do
    assert_difference("Image.count", -1) do
      delete image_url(@image)
    end

    assert_redirected_to images_url
  end
end
