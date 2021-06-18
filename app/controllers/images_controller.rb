# frozen_string_literal: true

class ImagesController < ApplicationController
  include Behaveable::ResourceFinder
  include Behaveable::RouteExtractor

  before_action :set_image, only: %i[show edit update destroy]

  # GET /images or /images.json
  def index
    @images = imageable.all

    respond_to do |format|
      format.html { render :index, status: :ok, location: extract(@behaveable) }
      format.json { render json: @images, status: :ok, location: extract(@behaveable) }
    end
  end

  # GET /images/1 or /images/1.json
  def show
    respond_to do |format|
      format.html { render :show, status: :ok, location: extract(@behaveable, @image) }
      format.json { render json: @image, status: :ok, location: extract(@behaveable, @image) }
    end
  end

  # GET /images/new
  def new
    @image = imageable.new
  end

  # GET /images/1/edit
  def edit
    respond_to do |format|
      format.html { render :show, status: :ok, location: extract(@behaveable, @image) }
      format.json { render json: @image, status: :ok, location: extract(@behaveable, @image) }
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength

  # POST /images or /images.json
  def create
    @image = imageable.new(image_params)

    respond_to do |format|
      @image.transaction do
        if @image.save
          imageable << @image if @behaveable
          format.html { redirect_to extract(@behaveable), notice: "Image was successfully created." }
          format.json { render json: @image, status: :created }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /images/1 or /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Get Image context object.
  #
  # ==== Returns
  # * <tt>ActiveRecord</tt> - Imageable's images or Image.
  def imageable
    @behaveable ||= behaveable
    @behaveable ? @behaveable.images : Image
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = imageable.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:name)
  end
end
