require 'fileutils'

module PhotoService
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
    photo_dir(screen_name).join('cropped.png')
  end

  def photo_path(screen_name)
    path = cropped_path(screen_name)
    return default_path unless File.file?(path)

    path
  end

  def raw_check(screen_name)
    path = raw_path(screen_name)
    File.file?(path)
  end

  def dir_check(dirname)
    return if Dir.exist?(dirname)

    FileUtils.mkdir_p(dirname)
  end

  def photo_dir(screen_name)
    Rails.root.join(Rails.configuration.x.photo_path, screen_name[0, 1], screen_name)
  end

  def default_path
    Rails.root.join('public', 'img', 'default_profile.png')
  end

  module_function :upload_cropped, :upload_raw, :raw_path, :cropped_path, :photo_path, :raw_check,
                  :dir_check, :photo_dir, :default_path
end
