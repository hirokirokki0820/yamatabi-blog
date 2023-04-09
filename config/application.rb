require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YamatabiBlog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"

    # ActiveStorage 上書きされないようにする
    config.active_storage.replace_on_assign_to_many = false

    # sanitaize allowed tags
    config.action_view.sanitized_allowed_tags = %w(h1 h2 h3 h4 h5 h6 ul ol li p span a img table tbody th tr td em br b strong)
    # config.action_view.sanitized_allowed_attributes = %w(id class href style src)

    # config.eager_load_paths << Rails.root.join("extras")
  end
end
