module ApplicationHelper

  #class MyFormBuilder < ActionView::Helpers::FormBuilder
  class MyFormBuilder < NestedForm::Builder

    def errors(method, options = {})
      unless object.errors[method].blank?
        @template.content_tag(:span, options) do
          object.errors[method].join("|")
        end
      end
    end

    def has_errors?(method, options = {})
      unless object.errors[method].blank?
        return 'error'
      end
    end

    def currency_field(method, options = {})
      @template.currency_field(@object_name, method, objectify_options(options))
    end
  end

  def show_note(note)
    "<pre class=\"note\">#{note.blank? ? 'nessuna nota' : note}</pre>".html_safe
  end


  def month_as_string(month_index)
    case month_index - 1
      when 0
        return "Gennaio"
      when 1
        return "Febbraio"
      when 2
        return "Marzo"
      when 3
        return "Aprile"
      when 4
        return "Maggio"
      when 5
        return "Giugno"
      when 6
        return "Luglio"
      when 7
        return "Agosto"
      when 8
        return "Settembre"
      when 9
        return "Ottobre"
      when 10
        return "Novembre"
      when 11
        return "Dicembre"
    end
  end

  def write_currency(value)
    number_to_currency(value, unit: "&euro;", format: "%n %u", separator: ",", delimiter: ".")
  end

  def show_flash
    unless flash.empty?
      render partial: 'dashboard/flash', locals: { flash: flash }
    end
  end
end