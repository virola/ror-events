class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, to: :@template

  %w( text_field password_field text_area url_field file_field collection_select select ).each do |method_name|
    define_method(method_name) do |method, *tag_value|
      content_tag(:div, class: 'form-group') do
        label(method, class: 'control-label') +
          # content_tag(:div, class: '') do
            super(method, *tag_value)
          # end
      end
    end
  end

  def error_messages
    if object && object.errors.any?
      content_tag(:div, id: 'error-explanation') do
        content_tag(:h3, "#{object.errors.count}个错误") +
          content_tag(:ul) do
            object.errors.full_messages.map do |msg|
              content_tag(:li, msg)
            end.join.html_safe
          end
      end
    end
  end
end