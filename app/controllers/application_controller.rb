class ApplicationController < ActionController::Base
    before_action :set_device_type



    private

    def set_device_type
      browser = Browser.new(request.user_agent)
      @device_type = browser.device.mobile? ? 'mobile' : 'desktop'
    end
    
end
