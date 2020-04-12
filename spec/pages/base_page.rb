require_relative '../spec_helper.rb'
require 'appium_capybara'
require 'capybara'
require 'appium_lib'

class BasePage < SitePrism::Page
  include SitePrism::DSL
  @@selector = {ANDROID: :id, IOS: :predicate}

  def self.get_default_selector(platform)
    if platform.downcase == 'android'
      return @@selector[:ANDROID]
    elsif platform.downcase == 'ios'
      return @@selector[:IOS]
    else
      raise ArgumentError, 'Wrong Platform name'
    end
  end

  def self.set_default_selector(android, ios)
    @@selector = {ANDROID: android, IOS: ios}
  end

  def self.find_platform_locator(*find_args)
    platform = ENV['PLATFORM'].upcase
    if (find_args.length == 2) && (platform == 'ANDROID')
      find_args.delete_at(1)
    elsif (find_args.length == 2) && (platform == 'IOS')
      find_args.delete_at(0)
    end

    if find_args[0].split(':').length == 2
      selectors = find_args[0].split(':')
      return selectors[0].to_sym, selectors[1]
    else
      return [BasePage.get_default_selector(platform), find_args[0]]
    end
  end

  def self.element(name, *find_args)
    m_find_args = find_platform_locator(*find_args)
    super(name, *m_find_args)
  end

  def self.elements(name, *find_args)
    m_find_args = find_platform_locator(*find_args)
    super(name, *m_find_args)
  end
end