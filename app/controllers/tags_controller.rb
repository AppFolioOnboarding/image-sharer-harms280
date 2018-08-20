class TagsController < ApplicationController
  def show
    tag_name = params[:name]

    @tag = ActsAsTaggableOn::Tag.find_by(name: tag_name)
    @images = Image.tagged_with(tag_name)

    flash.now.alert = "Tag #{tag_name} does not exist" if @tag.nil?

    render locals: { name: params[:name] }
  end
end
