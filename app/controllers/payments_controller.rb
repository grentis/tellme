class PaymentsController < ApplicationController
  before_filter :find_payment, only: [:mark, :destroy]

  def by_month
    render partial: "payments/payments", locals: { payments: Payment.for_index(params[:month].to_i) }
  end

  def mark
    @payment.paid = !@payment.paid
    if @payment.save
      @expired = Payment.expired
      render :update_payment
    else
      flash.now[:alert] = "Si e' verificato un errore"
      render nothing: true
    end
  end

  def destroy
    if @payment.destroy
      redirect_to root_path, notice: 'Rata cancellata con successo'
    else
      redirect_to root_path, alert: 'Errore nella cancellazione della rata'
    end
  end

  private

    def find_payment
      @payment = Payment.find(params[:id])
    end

end
