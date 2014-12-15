class QuickAdmin::BaseController < QuickAdmin.parent_controller.constantize
  respond_to :html, :js, :json

  module InstanceMethods

    def collection
      get_collection_ivar || begin
        @grid = resource_collection_name.to_s.camelize.constantize.new(params[resource_collection_name])
        @assets = @grid.assets.page(params[:page])
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
  end

  def self.inherited klass
    klass.inherit_resources
    klass.include InstanceMethods
  end

  def should_authorize?
    ApplicationController.include?(Pundit) rescue false
  end

end