class ShareEmail
  include ActiveModel::Model

  attr_accessor(
    :address,
    :message
  )

  validates :address, presence: true,
                      format: { with: URI::MailTo::EMAIL_REGEXP, message: 'has invalid format' }
end
