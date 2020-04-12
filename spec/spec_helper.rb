require 'appium_capybara'
require 'rspec'
require 'site_prism'
require 'allure-rspec'
require 'allure-ruby-commons'
require 'capybara/rspec'
require 'rspec/expectations'
require 'pages/app'
require 'capybara-screenshot/rspec'
require 'rspec/retry'

ENV['SERVER'] ||= 'LOCAL'

def get_caps
  if ENV['SERVER'] == 'LOCAL'
    case ENV['PLATFORM']
    when 'IOS'
      puts "USING #{ENV['PLATFORM']}"
      Appium.load_appium_txt file: File.join(Dir.pwd, './spec/config/ios/appium.txt')
    when 'ANDROID'
      puts "USING #{ENV['PLATFORM']}"
      Appium.load_appium_txt file: File.join(Dir.pwd, './spec/config/android/appium.txt')
    else
      abort "[ERROR] Cant find platform #{ENV['PLATFORM']}, please define `APP` as environment variable"
    end
  end
end

Capybara.register_driver(:appium) do |app|
  opts = get_caps
  app_path = ENV['APP']
  if ENV['APP']
    opts[:caps][:app] = File.expand_path app_path
  end
  puts opts
  Appium::Capybara::Driver.new app, opts
end

Capybara.default_driver = :appium

Capybara.add_selector(:predicate) do
  custom(:predicate) { |locator| locator }
end

RSpec.configure do |config|
  config.formatter = AllureRspecFormatter
  config.include AllureRspec::AllureRspecModel
  config.include Capybara::RSpecMatchers
  config.filter_run_when_matching :focus
  config.warnings = true
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  Capybara.configure do |config|
    config.save_path = File.dirname(__FILE__) + "/../screenshots"
  end

  config.before(:example) do |example|
    @app ||= App.new
  end

  config.before(:all) do |example|
    # Autosave screenshot on failure by capybara
    Capybara::Screenshot.autosave_on_failure = false
    Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
      "screenshot_#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//,'')}"
    end
    Capybara::Screenshot.append_timestamp = true

    dirname = File.dirname(__FILE__) + "/../screenshots"
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end
  end

  config.after(:each) do |scenario|
    Capybara.current_session.driver.quit
  end

  config.after(:example) do |e|
    if e.exception != nil
      Dir.mkdir("./screenshots") unless Dir.exist?("./screenshots")
      # save the file locally
      file_name = page.save_screenshot
      # attaches failed test screenshot to Allure reports
      e.attach_file(e.metadata[:description] + ' (x'  + e.attempts.to_s + ')',
                    File.open(file_name))
    end
  end

  # RSpec Retry
  # show retry status in spec process
  config.verbose_retry = false
  # show exception that triggers a retry if verbose_retry is set to true
  config.display_try_failure_messages = true
  # run retry only on features
  config.around :each do |ex|
    ex.run_with_retry retry: (ENV['RETRY_COUNT'] || 2).to_i  # 2 means actually 1 retry
  end
end

Allure.configure do |c|
  c.results_directory = "allure-results"
  c.clean_results_directory = false
end