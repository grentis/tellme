class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_auth, :set_up_client_filter, :set_up_current_year
  after_filter :flash_to_headers

  def redirect_to(options = {}, response_status = {})
    if request.xhr?
      render js: "window.location.href='#{options}'"
    else
      super(options, response_status)
    end
  end

  private

    def check_auth
      redirect_to logout_path unless session[:user_id]
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def set_up_client_filter
      @client_filter = session[:client_filter]
    end

    def set_up_current_year
      @current_year = session[:current_year] || 0
    end

    def flash_to_headers
      return unless request.xhr?
      response.headers['X-Message'] = flash_message
      response.headers["X-Message-Type"] = flash_type.to_s
      flash.discard
    end

    def flash_message
      [:error, :warning, :notice].each do |type|
        return flash[type] unless flash[type].blank?
      end
      return ''
    end

    def flash_type
      [:error, :warning, :notice].each do |type|
        unless flash[type].blank?
          return type.to_s == 'notice' ? 'info' : type
        end
      end
    end
end
