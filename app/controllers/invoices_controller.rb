class InvoicesController < ApplicationController
  def index
    @invoice = Invoice.last
    (3 - @invoice.payments.count).times { @invoice.payments.build }
  end

  def new
    @invoice = Invoice.new
    3.times { @invoice.payments.build }
    render action: :index
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
       redirect_to dashboard_index_path
    else
       render action: :index
    end
  end

  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
       redirect_to :action => 'index'
    else
       render :action => 'index'
    end
  end
end
