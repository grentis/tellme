class ClientsController < ApplicationController
  def new
    @client = Client.new
    @from_invoice = params[:fi] || 0
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
      flash.now[:error] = 'sdadas'
      render action: :edit
    end
  end

  def cancel
  end

  def create
    @client = Client.new(params[:client])
    @from_invoice = params[:from_invoice]
    if @client.save
      if @from_invoice == 1.to_s
        render 'update_invoice_form'
      else
        redirect_to dashboard_index_path
      end
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
