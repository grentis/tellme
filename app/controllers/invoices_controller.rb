class InvoicesController < ApplicationController

  def new
    @invoice = Invoice.new( { client_id: params[:client_id] } )
    3.times { @invoice.payments.build }
    render action: :edit
  end

  def edit
    @invoice = Invoice.find(params[:id])
    (3 - @invoice.payments.count).times { @invoice.payments.build }
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
       redirect_to dashboard_index_path
    else
       render action: :edit
    end
  end

  def cancel
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
       redirect_to dashboard_index_path
    else
       render action: :edit
    end
  end
end
