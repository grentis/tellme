class PaymentsController < ApplicationController

  def by_month
    render partial: "payments/payments", locals: { payments: Payment.by_index(params[:month].to_i) }
  end

  def mark
    @payment = Payment.find(params[:id])
    @payment.paid = !@payment.paid
    if @payment.save
      @expired = Payment.expired
      render :update_payment
    else
      #TODO: mettere l'updare js del flash message
      render nothing: true
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    if @payment.destroy
      redirect_to dashboard_index_path
    else
      redirect_to dashboard_index_path
    end
  end

end
