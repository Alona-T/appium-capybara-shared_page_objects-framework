require 'appium_capybara'
require 'rspec'
require 'site_prism'

Capybara.register_driver(:appium) do |app|
  opts = Appium.load_appium_txt file: File.join(Dir.pwd, "spec/config/#{ENV['PLATFORM'].downcase}/appium.txt")
  Appium::Capybara::Driver.new app, opts
end

Capybara.default_driver = :appium