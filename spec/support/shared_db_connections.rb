# the following is needed to make acceptance tests
# with rspec + selenium work, more info here:
# http://stackoverflow.com/questions/8774227/why-not-use-shared-activerecord-connections-for-rspec-selenium
# http://stackoverflow.com/questions/8178120/capybara-with-js-true-causes-test-to-fail

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
 
  def self.connection
    @@shared_connection || retrieve_connection
  end
end
 
# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection