class SessionsController < ApplicationController
  skip_before_filter :check_auth, only: [:new, :create, :destroy]

  layout 'login'

  def filter_by_client
    begin
      @client = Client.find(params[:filter_client_id])
      session[:client_filter] = @client.id
    rescue ActiveRecord::RecordNotFound
      session[:client_filter] = nil
    end
    render nothing: true
  end

  def new
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged in!"
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
