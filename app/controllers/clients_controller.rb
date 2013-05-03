class ClientsController < ApplicationController
  before_filter :find_client, only: [:edit, :show, :update, :destroy]

  def new
    @client = Client.new
    @from_invoice = params[:fi] || 0
    render action: :edit
  end

  def edit
  end

  def show
  end

  def update
    if @client.update_attributes(params[:client])
      flash.now[:notice] = 'Cliente aggiornato con successo'
      redirect_to root_path
    else
      render action: :edit
    end
  end

  def cancel
  end

  def create
    @client = Client.new(params[:client])
    @from_invoice = params[:from_invoice]
    if @client.save
      flash.now[:notice] = 'Cliente creato con successo'
      if @from_invoice == 1.to_s
        render 'update_invoice_form'
      else
        redirect_to root_path
      end
    else
      render action: :edit
    end
  end

  def destroy
    if @client.destroy
      redirect_to root_path, notice: 'Cliente cancellato con successo'
    else
      redirect_to root_path, alert: 'Errore nella cancellazione del cliente'
    end
  end

  private

    def find_client
      @client = Client.find(params[:id])
    end
end
