# Appium-Capybara framework with shared PageObject and Test classes for both platforms
This framework can be used by QA Engineers for testing Native Mobile apps with a help of RSpec and Rake execution.


# Features
 - appium-capybara (https://github.com/appium/appium_capybara)
 - Page Object model
 - Shared classes between Android and iOS
 - Allure Report

# How to start 
 - Clone the project
 - Do ```bundle install```
 - In Config/ folder change the app path to your path (apps are attached to the root of this project)
 - For running tests you can use rake tasks - as example
 - ```rake run_tests[android]```for Android platform
 - ```rake run_tests[ios]```for iOS platform
 
 - to view Allure report do ```allure serve```
 
 
 # Collaborators:
  - @serhatbolsu (https://github.com/serhatbolsu)
