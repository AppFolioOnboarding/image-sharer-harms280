class ImageMailer < ApplicationMailer
  def share_image
    @image = Image.find_by(id: params[:id])
    @email = params[:share_email]
    mail(to: @email[:address], subject: 'Sharing this image with you')
  end
end
