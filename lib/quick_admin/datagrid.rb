require 'datagrid'

#
module Datagrid
  #
  class Columns::Column
    alias_method :header_original, :header
    def header
      options[:header] ||= proc do
        grid_class.scope_value.call.human_attribute_name(name)
      end.call
    rescue
      Rails.logger.warn "Datagrid Patch ERROR: #{$ERROR_INFO}"
    ensure
      header_original
    end
  end

  #
  class Filters::BaseFilter
    alias_method :header_original, :header
    def header
      options[:header] ||= proc do
        grid_class.scope_value.call.human_attribute_name(name)
      end.call
    rescue
      Rails.logger.warn "Datagrid Patch ERROR: #{$ERROR_INFO}"
    ensure
      header_original
    end
  end

  class Renderer
  end
end
