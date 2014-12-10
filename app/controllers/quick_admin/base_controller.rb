class QuickAdmin::BaseController < QuickAdmin.parent_controller.constantize
  respond_to :html, :js, :json

  module InstanceMethods
    def collection
      get_collection_ivar || begin
        @grid = resource_collection_name.to_s.camelize.constantize.new(params[resource_collection_name])
        @assets = @grid.assets.page(params[:page])
        set_collection_ivar @assets
      end
    end
  end

  def self.inherited klass
    klass.inherit_resources
    klass.include InstanceMethods
  end

end