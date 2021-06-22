# frozen_string_literal: true

class ImagesController < ApplicationController
  include Behaveable::ResourceFinder
  include Behaveable::RouteExtractor

  before_action :set_image, only: %i[show edit update destroy]

  # GET /images or /images.json
  def index
    @images = imageable.all

    respond_to do |format|
      format.html { render :index, status: :ok, location: extract(behaveable: @behaveable) }
      format.json { render json: @images, status: :ok, location: extract(behaveable: @behaveable) }
    end
  end

  # GET /images/1 or /images/1.json
  def show
    respond_to do |format|
      format.html { render :show, status: :ok, location: polymorphic_url([@behaveable, @image]) }
      format.json { render json: @image, status: :ok, location: polymorphic_url([@behaveable, @image]) }
    end
  end

  # GET /images/new
  def new
    @image = imageable.new
    respond_to do |format|
      format.html { render :new, status: :ok, location: polymorphic_url([@behaveable, @image]) }
      format.json { render json: @image, status: :ok, location: polymorphic_url([@behaveable, @image]) }
    end
  end

  # GET /images/1/edit
  def edit
    respond_to do |format|
      format.html { render :edit, status: :ok, location: extract(behaveable: @behaveable, resource: @image) }
      format.json do
        render json: @image, status: :ok, location: extract(behaveable: @behaveable, resource: @image)
      end
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

          @image.attachment.attach(params[:image][:attachment]) if params[:image][:attachment]

          format.html do
            redirect_to polymorphic_url([@behaveable, @image]), notice: "Image was successfully created."
          end
          format.json do
            render json: @image, status: :created, location: polymorphic_url([@behaveable, @image])
          end
        else
          format.html do
            render :new, status: :unprocessable_entity, location: polymorphic_url([@behaveable, @image])
          end
          format.json do
            render json: @image.errors, status: :unprocessable_entity,
                   location: polymorphic_url([@behaveable, @image])
          end
        end
      end
    end
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /images/1 or /images/1.json
  def update # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if @image.update(image_params)
        format.html do
          redirect_to polymorphic_url([@behaveable, @image]), notice: "Image was successfully updated."
        end
        format.json { render :edit, status: :ok, location: polymorphic_url([@behaveable, @image]) }
      else
        format.html do
          render :edit, status: :unprocessable_entity,
                        location: polymorphic_url([@behaveable, @image])
        end
        format.json do
          render json: @image.errors, status: :unprocessable_entity,
                 location: polymorphic_url([@behaveable, @image])
        end
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to extract(behaveable: @behaveable), notice: "Image was successfully destroyed." }
      format.json { head :no_content, location: extract(behaveable: @behaveable) }
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
    params.require(:image).permit(
      :name,
      :attachment
    )
  end
end
