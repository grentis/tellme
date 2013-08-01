module ActionView
  module Helpers
    module FormHelper
      def form_for_with_errors(record, options = {}, &proc)
        options[:builder] = ApplicationHelper::MyFormBuilder
        form_for_without_errors(record, options, &proc)
      end
 
      def fields_for_with_errors(record_name, record_object = nil, options = {}, &block)
        options[:builder] = ApplicationHelper::MyFormBuilder
        fields_for_without_errors(record_name, record_object, options, &block)
      end

      alias_method_chain :form_for, :errors
      alias_method_chain :fields_for, :errors

      def currency_field(object_name, method, options = {})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_currency_field_tag("text", options)
      end
    end

    class InstanceTag
      include ActionView::Helpers::NumberHelper

      def to_currency_field_tag(field_type, options = {})
        options = options.stringify_keys
        options["size"] = options["maxlength"] || DEFAULT_FIELD_OPTIONS["size"] unless options.key?("size")
        options = DEFAULT_FIELD_OPTIONS.merge(options)
        if field_type == "hidden"
          options.delete("size")
        end
        options["type"]  ||= field_type
        options["value"] = options.fetch("value"){ value_before_type_cast(object) } unless field_type == "file"
        options["value"] = number_with_precision(options["value"], precision: 2, delimiter: '.', separator: ',') unless options["value"].blank? 
        options["value"] &&= ERB::Util.html_escape(options["value"])
        add_default_name_and_id(options)
        tag("input", options)
      end
    end
  end
end