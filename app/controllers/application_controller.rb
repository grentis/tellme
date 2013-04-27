class ApplicationController < ActionController::Base
  protect_from_forgery

  def redirect_to(options = {}, response_status = {})
    if request.xhr?
      puts options
      render js: "window.location.href='#{options}'"
    else
      super(options, response_status)
    end
  end
end
