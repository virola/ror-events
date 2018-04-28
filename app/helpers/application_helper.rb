module ApplicationHelper
  def bootstrap_form_for(object, options = {}, &block)
    options[:html] ||= {}
    options[:html][:class] = 'form col-12 col-md-6'
    options[:html]['data-parsley-validate'] = true
    options[:builder] = BootstrapFormBuilder
    form_for(object, options, &block)
  end

  # json format
  def j_format json, status = 200, errors = nil
    json.status (status.between?(200, 300) ? 'ok' : status)
    json.data do
      yield if block_given?
    end
    json.message (errors ? errors : json.message)
  end
end
