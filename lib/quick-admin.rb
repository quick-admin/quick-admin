require 'rails'
require 'kaminari'
require 'inherited_resources'
require 'simple_form'

module QuickAdmin

  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

end

require 'quick_admin/rails'
require 'quick_admin/datagrid'