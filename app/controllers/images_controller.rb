class ImagesController < ApplicationController
  before_action :validate_image_exists, only: %i[show edit update destroy send_share_email]

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
    @email = ShareEmail.new
  end

  def new
    @image = Image.new
  end

  def edit; end

  def create
    @image = Image.new(image_params)

    if @image.save
      flash[:success] = 'You have successfully added an image.'
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @image.update(image_update_params)
      flash[:success] = 'You have successfully updated an image'
      redirect_to @image
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @image.destroy

    flash[:success] = 'You have successfully deleted the image.'
    redirect_to images_path
  end

  def send_share_email
    @email = ShareEmail.new(email_params)

    handle_email_send
  rescue StandardError
    flash[:danger] = 'Problem sending email'
    render :share, status: :unprocessable_entity
  end

  private

  def image_params
    params.require(:image).permit(:link, :tag_list)
  end

  def image_update_params
    params.require(:image).permit(:tag_list)
  end

  def validate_image_exists
    @image = Image.find_by(id: params[:id])
    return if @image

    flash[:warning] = 'Image does not exist.'
    redirect_to images_path
  end

  def email_params
    params.require(:share_email).permit(:address, :message)
  end

  def handle_email_send
    respond_to do |format|
      if @email.valid?
        ajax_send_email_ajax(format)
      else
        notify_email_failed_ajax(format)
      end
    end
  end

  def ajax_send_email_ajax(format)
    ImageMailer.with(params).share_image.deliver
    flash.now[:success] = 'Email has been successfully sent'
    format.json { render json: flash }
  end

  def notify_email_failed_ajax(format)
    flash.now[:danger] = 'Form requires a valid email'
    format.json { render json: { errors: @email.errors, flash: flash }, status: :unprocessable_entity }
  end
end
