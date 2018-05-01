require 'fileutils'

module PhotoService extend self
  def upload_cropped(screen_name, photo)
    dir_check(photo_dir(screen_name))

    File.open(cropped_path(screen_name), 'wb') do |file|
      file.write(photo)
    end
  end

  def upload_raw(screen_name, photo)
    dir_check(photo_dir(screen_name))

    File.open(raw_path(screen_name), 'wb') do |file|
      file.write(photo.read)
    end
  end

  def raw_path(screen_name)
    photo_dir(screen_name).join('raw.png')
  end

  def cropped_path(screen_name)
    return default_path unless Dir.exists?(photo_dir(screen_name))
    photo_dir(screen_name).join('cropped.png')
  end

  def raw_check(screen_name)
    path = raw_path(screen_name)
    File.file?(path)
  end

  def dir_check(dirname)
    if !Dir.exists?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end

  def photo_dir(screen_name)
    Rails.root.join(Rails.configuration.x.photo_path, screen_name[0, 1], screen_name)
  end

  def default_path
    Rails.root.join('public', 'img', 'default_profile.png')
  end
end
