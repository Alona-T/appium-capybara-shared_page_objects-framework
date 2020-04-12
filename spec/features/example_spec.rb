require 'spec_helper'

feature 'Dashboard tests' do

  scenario "Verify screen title" do
    expect(@app.dashboard.page_text.visible?).to be(false)
  end
end

