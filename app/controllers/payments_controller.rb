class PaymentsController < ApplicationController

  def by_month
    render partial: "payments/payments", locals: { payments: Payment.by_index(params[:month].to_i) }
  end

end
