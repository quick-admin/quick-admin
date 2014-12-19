require 'rails'
require 'kaminari'
require 'inherited_resources'
require 'simple_form'
require 'nprogress-rails'

module QuickAdmin

  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  mattr_accessor :parent_layout
  @@parent_layout = "layouts/application"

  mattr_accessor :root_path
  @@root_path = "/"

end

require 'quick_admin/rails'
require 'quick_admin/datagrid'