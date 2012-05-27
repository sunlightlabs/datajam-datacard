module Admin::MappingRequestsHelper
  def mapping_field_for(form, field)
    form.input field.name, {
      as:          field.type.to_sym,
      hint:        field.help_text,
      label:       field.title,
      collection:  field.options,
      placeholder: field.placeholder,
      prompt:      field.prompt,
    }
  end
end
