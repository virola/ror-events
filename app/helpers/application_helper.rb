module ApplicationHelper
  def bootstrap_form_for(object, options = {}, &block)
    options[:html] ||= {}
    options[:html][:class] = 'form col-12 col-md-6'
    options[:html]['data-parsley-validate'] = true
    options[:builder] = BootstrapFormBuilder
    form_for(object, options, &block)
  end
end
