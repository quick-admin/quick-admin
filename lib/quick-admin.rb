require 'rubygems'
require 'rails'
require 'kaminari'
require 'meta_tags'
require 'responders'
require 'simple_form'
require 'nprogress-rails'
require 'haml-rails'
require 'coffee-rails'
require 'jquery-rails'
#require 'sprockets-rails'
require 'semantic-ui-sass'

#
module QuickAdmin
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  mattr_accessor :parent_layout
  @@parent_layout = 'layouts/application'

  mattr_accessor :root_path
  @@root_path = '/'
end

require 'quick_admin/rails'
require 'quick_admin/datagrid'
