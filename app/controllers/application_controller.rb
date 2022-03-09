class ApplicationController < ActionController::Base

    helper_method :logged_in?

    # this is just to get some variables working for main layout until models are set up
    def logged_in?
        false

    end
end
