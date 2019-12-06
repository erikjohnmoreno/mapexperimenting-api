SparkPostRails.configure do |c|
  c.api_key = Rails.configuration.settings['sparkpost_api_key']
  c.inline_css = true
  c.html_content_only = true
end
