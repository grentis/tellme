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

    def currency_field(method, options = {})
      @template.currency_field(@object_name, method, objectify_options(options))
    end
  end
end