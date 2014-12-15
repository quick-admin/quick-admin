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
      @vendor_platform ||= proc do
        authorize super if should_authorize?
        super
      end.call
    end

    def build_resource
      @vendor_platform ||= proc do
        authorize super if should_authorize?
        super
      end.call
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