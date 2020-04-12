require 'rake'
require 'rspec/core/rake_task'
require 'json'
require 'uri'
require 'net/http'

task :run_tests, [:platform] do |_task, args|
  platform = args.platform.upcase

  ENV['SERVER'] = 'LOCAL'
  ENV['PLATFORM'] = platform
  ENV['RETRY_COUNT'] = 2.to_s # actually means 1 retry
  ENV['ALLURE_RUN'] = 'YES' # For Allure to put steps
  puts "<< Platform: #{args.platform} >>"
  mkdir_p(["./tmp"], verbose: false )
  system "rspec spec/features/*_spec.rb" +
             " --format progress" +
             " -f json -o tmp/run.json"

  if Dir.exist?('allure-results')
    environment_stats = "Platform=#{platform.capitalize}\n" +
        "Retry.Count=#{ENV['RETRY_COUNT']}"

    File.open('allure-results/environment.properties', 'w') do |f|
      f.write(environment_stats)
    end
  end
end

task :clean do
  rm_rf "tmp"
  rm_rf "allure-report"
  rm_rf "allure-results"
  rm_rf "screenshots"
end