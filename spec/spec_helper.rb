ENV['RACK_ENV'] = 'test'

require 'capybara/rspec'
require 'capybara/dsl'
require 'rack/test'
require_relative '../server.rb'
require_relative '../app/create_tables.rb'

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods

  config.before(:each) do
    conn = PG.connect(dbname: 'rebase_labs_data',
      user: 'user',
      password: 'password',
      host: 'rebase_db')

    create_tables(conn)
  end

end
