module Admin::MappingRequestsHelper
  def mapping_field_for(form, field, value=nil)
    options = field.options
    options = options.invert if options.respond_to?(:invert)
    
    form.input field.name, {
      as:          (field.type || :string).to_sym,
      hint:        field.help_text,
      label:       field.title,
      collection:  options,
      placeholder: field.placeholder,
      prompt:      field.prompt,
      input_html:  { value: value },
    }
  end
end
