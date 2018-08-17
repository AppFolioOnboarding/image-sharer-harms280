class Image < ApplicationRecord
  URL_REGEX = %r{ \A(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix

  validates :link, presence: true,
                   format: { with: URL_REGEX, message: 'invalid URL. Link requires http or https' }

  acts_as_taggable
end
