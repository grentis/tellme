class ClientsController < ApplicationController
  def new
    @client = Client.new
    render action: :edit
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      redirect_to dashboard_index_path
    else
      render action: :edit
    end
  end

  def cancel
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      redirect_to dashboard_index_path
    else
      render action: :edit
    end
  end

  def destroy
    @client = Client.find(params[:id])
    if @client.destroy
      redirect_to dashboard_index_path
    else
      redirect_to dashboard_index_path
    end
  end
end
