# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  #storage :file
  #storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  version :to_post do
    process :resize_to_fill => [500,500]
    process :hipster_filter
  end
  
  version :thumb do
    process :resize_to_fill => [300,300]
    process :hipster_filter
  end
  
  def hipster_filter
    manipulate! do |img|
      cols, rows = img[:dimensions]

      img.combine_options do |cmd|
        cmd.auto_gamma
        cmd.modulate '120,50,100'
      end

      new_img = img.clone
      new_img.combine_options do |cmd|
        cmd.fill 'rgba(227,195,129,0.3)'
        cmd.draw "rectangle 0,0 #{cols},#{rows}"
      end

      img = img.composite new_img do |cmd|
        cmd.compose 'multiply'
      end

      img = yield(img) if block_given?
      img
    end
  end
  

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
