class InvoicesController < ApplicationController
  def index
    @invoice = Invoice.last
    (3 - @invoice.payments.count).times { @invoice.payments.build }
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
