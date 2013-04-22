class ApplicationController < ActionController::Base
  protect_from_forgery

  def redirect_to(options = {}, response_status = {})
    if request.xhr?
      render js: "window.location.pathname='#{options}'"
    else
      super(options, response_status)
    end
  end
end
