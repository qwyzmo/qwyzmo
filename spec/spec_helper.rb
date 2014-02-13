require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Checks for pending migrations before tests are run.
  # If you are not using ActiveRecord, you can remove this line.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"
    # Include the Capybara DSL so that specs in spec/requests still work.
    config.include Capybara::DSL
    # Disable the old-style object.should syntax.
    config.expect_with :rspec do |c|
      c.syntax = :expect
    end
    
    def test_sign_in(user)
      controller.sign_in(user)
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end

def create_test_user(name, email, pass, passconf)
	test_user 											= User.new
	test_user.name 									= name
	test_user.email 								= email
	test_user.password 							= pass
	test_user.password_confirmation	= passconf
	test_user.status								= User::STATUS[:activated]
	test_user.save!
	test_user
end

def create_test_qwyz(user_id, name, question, description)
	test_qwyz 						= Qwyz.new
	test_qwyz.user_id 		= user_id
	test_qwyz.name 				= name
	test_qwyz.question 		= question
	test_qwyz.description = description
	test_qwyz.save!
	test_qwyz
end

def create_test_qwyz_item(qwyz_id, description)
	test_item 							= QwyzItem.new
	test_item.qwyz_id				= qwyz_id
	test_item.description		= description
	test_item.save!
	test_item
end










