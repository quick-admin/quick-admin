Bundler.require(*Rails.groups)

module QuickAdmin

  class Engine < ::Rails::Engine
    config.quick_admin = QuickAdmin
  end

end