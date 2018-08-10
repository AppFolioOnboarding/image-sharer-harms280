class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  private

  def image_params
    params.require(:image).permit(:link)
  end
end
