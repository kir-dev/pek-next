# frozen_string_literal: true

PDFKit.configure do |config|
  if ENV['USE_WKHTML_BINARY']
    config.wkhtmltopdf = 'vendor/wkhtmltopdf'
    config.default_options = {
      page_size: 'Legal',
      print_media_type: true,
      encoding: 'UTF-8'
    }
  end
end
