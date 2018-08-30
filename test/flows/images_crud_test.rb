require 'flow_test_helper'

class ImagesCrudTest < FlowTestCase
  test 'add an image' do
    images_index_page = PageObjects::Images::IndexPage.visit

    new_image_page = images_index_page.add_new_image!

    tags = %w[foo bar]
    new_image_page = new_image_page.create_image!(
      link: 'invalid',
      tags: tags.join(', ')
    ).as_a(PageObjects::Images::NewPage)
    assert_equal 'Link invalid URL. Link requires http or https', new_image_page.link.error_message

    image_url = 'https://media3.giphy.com/media/EldfH1VJdbrwY/200.gif'
    new_image_page.link.set(image_url)

    image_show_page = new_image_page.create_image!
    assert_equal 'You have successfully added an image.', image_show_page.flash_message(:success)

    assert_equal image_url, image_show_page.image_url
    assert_equal tags, image_show_page.tags

    images_index_page = image_show_page.go_back_to_index!
    assert images_index_page.showing_image?(link: image_url, tags: tags)
  end

  test 'update an image' do
    cute_puppy_url = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    tags = %w[puppy cute]
    Image.create!(link: cute_puppy_url, tag_list: tags.join(', '))

    images_index_page = PageObjects::Images::IndexPage.visit
    assert_equal 1, images_index_page.images.count
    assert images_index_page.showing_image?(link: cute_puppy_url, tags: tags)

    image_to_update = images_index_page.images.find do |image|
      image.link == cute_puppy_url
    end
    image_show_page = image_to_update.view!
    edit_image_page = image_show_page.edit!

    edit_image_page.tag_list.set('')
    edit_image_page = edit_image_page.update_image_invalid!.as_a(PageObjects::Images::EditPage)
    assert_equal "Tag list can't be blank", edit_image_page.tag_list.error_message

    updated_tags = %w[puppy cute updatedTag]
    edit_image_page.tag_list.set(updated_tags.join(', '))
    image_show_page = edit_image_page.update_image_valid!.as_a(PageObjects::Images::ShowPage)

    assert_equal 'You have successfully updated an image', image_show_page.flash_message(:success)

    assert_equal updated_tags, image_show_page.tags

    images_index_page = image_show_page.go_back_to_index!
    assert images_index_page.showing_image?(link: cute_puppy_url, tags: updated_tags)
  end

  test 'delete an image' do
    cute_puppy_url = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    ugly_cat_url = 'http://www.ugly-cat.com/ugly-cats/uglycat041.jpg'
    Image.create!([
      { link: cute_puppy_url, tag_list: 'puppy, cute' },
      { link: ugly_cat_url, tag_list: 'cat, ugly' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    assert_equal 2, images_index_page.images.count
    assert images_index_page.showing_image?(link: ugly_cat_url)
    assert images_index_page.showing_image?(link: cute_puppy_url)

    image_to_delete = images_index_page.images.find do |image|
      image.link == ugly_cat_url
    end
    image_show_page = image_to_delete.view!

    image_show_page.delete do |confirm_dialog|
      assert_equal 'Are you sure?', confirm_dialog.text
      confirm_dialog.dismiss
    end

    images_index_page = image_show_page.delete_and_confirm!
    assert_equal 'You have successfully deleted the image.', images_index_page.flash_message(:success)

    assert_equal 1, images_index_page.images.count
    assert_not images_index_page.showing_image?(link: ugly_cat_url)
    assert images_index_page.showing_image?(link: cute_puppy_url)
  end

  test 'view images associated with a tag' do
    puppy_url1 = 'http://www.pawderosa.com/images/puppies.jpg'
    puppy_url2 = 'http://ghk.h-cdn.co/assets/16/09/980x490/landscape-1457107485-gettyimages-512366437.jpg'
    cat_url = 'http://www.ugly-cat.com/ugly-cats/uglycat041.jpg'
    Image.create!([
      { link: puppy_url1, tag_list: 'superman, cute' },
      { link: puppy_url2, tag_list: 'cute, puppy' },
      { link: cat_url, tag_list: 'cat, ugly' }
    ])

    images_index_page = PageObjects::Images::IndexPage.visit
    [puppy_url1, puppy_url2, cat_url].each do |url|
      assert images_index_page.showing_image?(link: url)
    end

    images_index_page = images_index_page.images[1].click_tag!('cute')

    assert_equal 2, images_index_page.images.count
    assert_not images_index_page.showing_image?(link: cat_url)

    images_index_page = images_index_page.clear_tag_filter!
    assert_equal 3, images_index_page.images.count
  end
end
