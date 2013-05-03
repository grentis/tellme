class DashboardController < ApplicationController
  def index
    @clients = Client.find(:all, order: :name)
    @expired = Payment.expired
  end
end
