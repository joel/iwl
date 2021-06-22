# frozen_string_literal: true

require "application_system_test_case"

class PolymorphicImagesTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @image = create(:image)
    @user.images << @image
  end

  test "add image" do
    visit users_url
    assert_selector "h1", text: "Users"

    click_on "Add Image", match: :first
    fill_in "Name", with: @image.name
    attach_file "image_attachment", Rails.root.join("test/fixtures/favicon.ico")
  end

  test "visiting the index" do
    visit user_images_url(user_id: @user)
    assert_selector "h1", text: "Images"
  end

  test "creating a Image" do
    visit user_images_url(@user)
    click_on "New Image"

    fill_in "Name", with: @image.name
    click_on "Save"

    assert_text "Image was successfully created"
    click_on "Back"
  end

  test "updating a Image" do
    visit user_images_url(@user)
    click_on "Edit", match: :first

    fill_in "Name", with: @image.name
    click_on "Save"

    assert_text "Image was successfully updated"
    click_on "Back"
  end

  test "destroying a Image" do
    visit user_images_url(@user)

    click_on "Destroy", match: :first

    assert_text "Image was successfully destroyed"
  end
end
