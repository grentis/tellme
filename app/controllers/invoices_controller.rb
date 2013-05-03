class InvoicesController < ApplicationController
  before_filter :find_invoice, only: [:edit, :update, :destroy]

  def new
    @invoice = Invoice.new( { client_id: params[:client_id] } )
    3.times { @invoice.payments.build }
    render action: :edit
  end

  def edit
    (3 - @invoice.payments.count).times { @invoice.payments.build }
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      flash.now[:notice] = 'Fattura creata con successo'
      redirect_to root_path
    else
      render action: :edit
    end
  end

  def cancel
  end

  def update
    if @invoice.update_attributes(params[:invoice])
      flash.now[:notice] = 'Fattura aggiornata con successo'
      redirect_to root_path
    else
      render action: :edit
    end
  end

  def destroy
    if @invoice.destroy
      redirect_to root_path, notice: 'Fattura cancellata con successo'
    else
      redirect_to root_path, alert: 'Errore nella cancellazione della fattura'
    end
  end

  private

    def find_invoice
      @invoice = Invoice.find(params[:id])
    end
end
