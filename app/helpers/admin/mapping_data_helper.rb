module Admin::MappingDataHelper
  def mapping_field_for(form, field, value=nil)
    options = field.options
    options = options.invert if options.respond_to?(:invert)
    field_params = {
      as:          (field.type || :string).to_sym,
      hint:        field.help_text,
      label:       field.label,
      collection:  options,
      placeholder: field.placeholder,
      prompt:      field.prompt,
      input_html: { value: value },
    }
    field_params.merge!( selected: value ) if value.present? && field_params[:collection].present?
    form.input field.name, field_params
  end
end
