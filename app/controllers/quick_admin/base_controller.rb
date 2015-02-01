class QuickAdmin::BaseController < QuickAdmin.parent_controller.constantize
  respond_to :html, :js, :json

  module InstanceMethods

    def collection
      get_collection_ivar || begin
        @grid = build_grid
        @assets = @grid.assets.page(params[:page])
        # params[scopes[:type]] will get the attribute's value like 'status' during the filtering
        @scope = params[:scope] || params[scopes[:type]] || scopes[:default_scope] rescue nil
        unless scopes.blank?
          @assets = @assets.send(@scope)
          @type = scopes[:type]
          @scopes = scopes[:scopes]
        end
        authorize @assets if should_authorize?
        set_collection_ivar @assets
        scopes = nil
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
      resource_collection_name.to_s.camelize.constantize.new(params[resource_collection_name])
    end
  end

  def self.inherited klass
    klass.inherit_resources
    klass.send :include, InstanceMethods
  end

  cattr_accessor :scopes

  def should_authorize?
    ApplicationController.include?(Pundit) rescue false
  end

end