class ImagesController < ApplicationController
  def show
    # Comment out when Image model is generated
    # @image = Image.find(params[:id])
  end

  def new
    # Comment out when model is built
    # @image = Image.new
  end

  private

  def image_params
    params.require(:image).permit(:link)
  end
end
