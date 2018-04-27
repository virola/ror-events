require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventsCal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.assets.precompile += %w(....)
    # form builders
    config.autoload_paths << Rails.root.join('app', 'form_builders')
    # 语言设置
    # 指定 I18n 库搜索翻译文件的路径
    config.i18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]
    
    # 应用可用的区域设置白名单
    config.i18n.available_locales = [:en, 'zh-CN']
    
    # 修改默认区域设置（默认是 :en）
    config.i18n.default_locale = 'zh-CN'
    
    config.time_zone = 'Beijing'
  end
end
