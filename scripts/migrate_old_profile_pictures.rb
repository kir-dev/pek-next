#!/usr/bin/env ruby

require 'fileutils'
require 'rmagick'

# This script using rmagick, which is not included in gemfile and needs
# imagemagick library too, you should install them as prerequisits. Please do
# not add to project's gemfile!
# The photo's path should contains photos in the next structure:
#
# photoPath               - given directory
# |- f                    - dir named screenname's first letter
# |- g
# |  |- gasdf             - dir named screenname
# |  |- gggg
# |  |  |-nadsjknkjnk2    - one image with hashed name
#
# Output files will be generated in the same structure listed before, but there
# will be two files, a raw image, which contains the original image and a
# cropped one, which is square shaped along the image's shorter side. Both are
# in png format.

photos_path = ''
@output_path = ''

def check_directory(path, name)
  File.directory?(File.join(path, name)) && name != '.' && name != '..'
end

def copy(first_letter_dir, screenname_dir, photo_path, photo)
  Dir.mkdir(@output_path) unless Dir.exist?(@output_path)

  first_letter_path = File.join(@output_path, first_letter_dir)
  Dir.mkdir(first_letter_path) unless Dir.exist?(first_letter_path)

  screenname_path = File.join(first_letter_path, screenname_dir)
  Dir.mkdir(screenname_path) unless Dir.exist?(screenname_path)

  original_photo_path = File.join(photo_path, photo)

  thumb = Magick::Image.read(original_photo_path).first
  resolution = [thumb.rows, thumb.columns].min
  thumb.format = 'png'
  thumb.write(File.join(screenname_path, 'raw.png'))
  thumb.crop_resized!(resolution, resolution, Magick::CenterGravity)
  thumb.write(File.join(screenname_path, 'cropped.png'))
end

Dir.entries(photos_path).select do |first_letter_dir|
  next unless check_directory(photos_path, first_letter_dir)

  path = File.join(photos_path, first_letter_dir)
  Dir.entries(path).select do |screenname_dir|
    next unless check_directory(path, screenname_dir)

    photo_path = File.join(path, screenname_dir)
    Dir.entries(photo_path).select do |photo|
      next if File.directory?(File.join(photo_path, photo))

      puts photo
      copy(first_letter_dir, screenname_dir, photo_path, photo)
    end
  end
end
