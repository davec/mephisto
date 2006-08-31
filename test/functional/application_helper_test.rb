require File.dirname(__FILE__) + '/../test_helper'
require 'application_helper'

ApplicationHelperTestController = Class.new ApplicationController do
  # look at how i mock the action view request
  def request() self end
  def env
    @env ||= {}
  end
end

class ApplicationHelperTest < Test::Unit::TestCase
  fixtures :assets
  include ActionView::Helpers::TagHelper
  include ApplicationHelper
  
  def test_should_return_default_avatar_for_nil_users
    assert_equal 'avatar.gif', gravatar_url_for(nil)
  end

  def test_should_return_movie_icon_for_movie
    assert_match /video\.png/, asset_image_for(assets(:mov))
  end
  
  def test_should_return_audio_icon_for_mp3
    assert_match /audio\.png/, asset_image_for(assets(:mp3))
  end
  
  def test_should_return_doc_icon_for_other
    assert_match /doc\.png/, asset_image_for(assets(:pdf))
    assert_match /doc\.png/, asset_image_for(assets(:word))
  end
  
  def test_should_return_pdf_preview_in_safari
    controller.env['HTTP_USER_AGENT'] = 'Webkit'
    assert_match assets(:pdf).public_filename, asset_image_for(assets(:pdf))
  end

  def test_should_return_thumbnail
    assert_match assets(:gif).public_filename(:tiny), asset_image_for(assets(:gif))
  end

  def test_should_return_actual_image
    assert_match assets(:png).public_filename, asset_image_for(assets(:png))
  end

  protected
    def asset_image_args_for(*args)
      controller.send(:asset_image_args_for, *args)
    end
    
    def controller
      @controller ||= ApplicationHelperTestController.new
    end
  
    def image_tag(path, options = {})
      tag 'img', options.merge(:src => path)
    end
end
