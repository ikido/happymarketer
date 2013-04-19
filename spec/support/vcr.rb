VCR.configure do |c|
  c.cassette_library_dir  = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.ignore_localhost = true
end

RSpec.configure do |c|
  default_options = {
    :record => :new_episodes
  }
  
  c.treat_symbols_as_metadata_keys_with_true_values = true  
  
  c.around(:each, :vcr) do |example|
    puts example.metadata[:full_description]
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, default_options.merge(options)) { example.call }
  end
end
