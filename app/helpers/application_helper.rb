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
    "<pre class=\"note\">#{note.blank? ? 'nessuna nota' : note}</pre>"
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
    write_currency_format(value, "&euro;", "%n %u")
  end

  def write_currency_txt(value)
    write_currency_format(value, "€", "%n%u")
  end

  def write_safe_txt(value)
    value.html_safe unless value == nil
  end

  def write_currency_format(value, unit, format)
    number_to_currency(value, unit: unit, format: format, separator: ",", delimiter: ".")
  end

  def show_flash
    unless flash.empty?
      render partial: 'dashboard/flash', locals: { flash: flash }
    end
  end

  def flash_message
    [:error, :warning, :notice].each do |type|
      return flash[type] unless flash[type].blank?
    end
    return ''
  end

  def flash_type
    [:error, :warning, :notice].each do |type|
      unless flash[type].blank?
        return type.to_s == 'notice' ? 'info' : type
      end
    end
  end
end