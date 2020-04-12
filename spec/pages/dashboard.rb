require_relative 'base_page'

class Dash < BasePage
  #element contains locators for both - android and ios respectively
  element :page_text, 'xpath://hierarchy/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[2]/android.widget.RelativeLayout/android.widget.TextView', 'name == "AAPLActionSheetViewController"'
end

