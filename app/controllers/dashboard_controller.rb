class DashboardController < ApplicationController
  def index
    @clients = Client.find(:all, order: :name)
    @expired = Payment.expired
  end

  def prev_year
    @current_year = @current_year - 1
    session[:current_year] = @current_year
    render 'change_year'
  end

  def next_year
    @current_year = @current_year + 1
    session[:current_year] = @current_year
    render 'change_year'
  end
end
