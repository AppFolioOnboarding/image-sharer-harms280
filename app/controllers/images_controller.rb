class ImagesController < ApplicationController
  before_action :validate_image_exists, only: %i[show destroy]

  def index
    tag_name = params[:tag]

    if tag_name
      @tag = ActsAsTaggableOn::Tag.find_by(name: tag_name)
      @images = Image.tagged_with(tag_name).order('created_at DESC')

      flash.now.alert = "Tag #{tag_name} does not exist" if @tag.nil?
    else
      @images = Image.all.order('created_at DESC')
    end
  end

  def show; end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if @image.save
      flash[:success] = 'You have successfully added an image.'
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @image.destroy

    flash[:success] = 'You have successfully deleted the image.'
    redirect_to images_path
  end

  private

  def image_params
    params.require(:image).permit(:link, :tag_list)
  end

  def validate_image_exists
    @image = Image.find_by(id: params[:id])
    return if @image

    flash[:warning] = 'Image does not exist.'
    redirect_to images_path
  end
end
