# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
dir = File.dirname(__FILE__)
$LOAD_PATH << File.join(dir)
%w[].each do |mod|
  $LOAD_PATH << File.join(File.join(dir), "../../#{mod}/lib")
end
Dir[File.join(dir, "support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.filter_run_excluding :online => true
end
