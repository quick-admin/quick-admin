class QuickAdmin::BaseController < QuickAdmin.parent_controller.constantize
  respond_to :html, :js, :json

  module InstanceMethods
    def collection
      get_collection_ivar || begin
        @grid = build_grid
        @assets = @grid.assets.page(params[:page])
        # params[scopes[:type]] will get the attribute's value like 'status' during the filtering
        @scope = params[:scope] || params[scopes[:type]] || scopes[:default_scope] rescue nil
        controller_name = scopes[:controller] rescue nil
        if !scopes.blank? && controller_name == self.class.name
          @assets = @assets.send(@scope)
          @type = scopes[:type]
          @scopes = scopes[:scopes]
        else
          @scope = nil
        end
        authorize @assets if should_authorize?
        set_collection_ivar @assets
      end
    end

    def resource
      get_resource_ivar || begin
        operated_resource = super
        authorize operated_resource if should_authorize?
        set_resource_ivar operated_resource
      end
    end

    def build_resource
      get_resource_ivar || begin
        operated_resource = super
        authorize operated_resource if should_authorize?
        set_resource_ivar operated_resource
      end
    end

    def build_grid
      grid_class = resource_class.name.pluralize.constantize
      grid_class.new(params[grid_class.model_name.param_key])
    end
  end

  def self.inherited(klass)
    klass.inherit_resources
    klass.send :include, InstanceMethods
  end

  cattr_accessor :scopes

  def should_authorize?
    ApplicationController.include?(Pundit) rescue false
  end
end
