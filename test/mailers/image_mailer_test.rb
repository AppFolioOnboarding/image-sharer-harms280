require 'test_helper'

class ImageMailerTest < ActionMailer::TestCase
  test 'share_image' do
    image = Image.create!(link: 'https://www.massinsight.org/wp-content/uploads/2016/05/placeholder-4-500x300.png',
                          tag_list: 'tag1 tag2 tag3')

    params = { id: image[:id], email: { address: 'friend@example.com',
                                        message: 'This is a message to send the person' } }

    email = ImageMailer.with(params).share_image

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['noreply@example.com'], email.from
    assert_equal ['friend@example.com'], email.to
    assert_equal 'Sharing this image with you', email.subject
  end
end
