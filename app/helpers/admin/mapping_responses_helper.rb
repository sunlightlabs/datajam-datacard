module Admin::MappingResponsesHelper
  def checkboxed_headers_list(f, headers)
    headers.map do |h|
      [ check_box_tag("card[response_fields][]", h.to_s), 
        content_tag(:span, h) 
      ].join.html_safe
    end
  end
end
