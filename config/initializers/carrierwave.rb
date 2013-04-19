CarrierWave.configure do |config|
  # config.fog_credentials = {
  #   :provider               => 'AWS',
  #   :aws_access_key_id      => ENV['HAPPYMARKETER_AWS_ACCESS_KEY'],
  #   :aws_secret_access_key  => ENV['HAPPYMARKETER_AWS_SECRET_KEY'],
  #   :region                 => ENV['HAPPYMARKETER_AWS_REGION'],
  #   :host                   => ENV['HAPPYMARKETER_AWS_HOST'],
  #   :endpoint               => ENV['HAPPYMARKETER_AWS_ENDPOINT']
  # }
  # config.fog_directory  = 'happy_marketer'
  config.storage :file
end

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end
end