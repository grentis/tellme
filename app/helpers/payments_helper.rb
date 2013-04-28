module PaymentsHelper
  def label_tag(payment, source = 'expired')
    if payment.paid?
      return content_tag :span, class: 'label label-success pull-left'  do
        "pagato"
      end
    elsif payment.expired?
      return content_tag :span, class: 'label label-important pull-left' do
        if source == 'expired'
          payment.v_date
        else
          "non pagato"
        end
      end
    else
      return content_tag :span, class: 'label label-info pull-left'  do
        "da pagare"
      end
    end
  end
end
