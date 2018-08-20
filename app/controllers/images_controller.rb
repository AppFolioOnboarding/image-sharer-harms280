class ImagesController < ApplicationController
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

  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)

    if @image.save
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def image_params
    params.require(:image).permit(:link, :tag_list)
  end
end
