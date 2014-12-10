require 'datagrid'

class Datagrid::Columns::Column
  alias_method :header_original, :header
  def header
    self.options[:header] ||= proc do
      self.grid_class.scope_value.call.human_attribute_name(self.name)
    end.call
  rescue
    Rails.logger.warn "Datagrid Patch ERROR: #{$!}"
  ensure
    header_original
  end
end

class Datagrid::Filters::BaseFilter
  alias_method :header_original, :header
  def header
    self.options[:header] ||= proc do
      self.grid_class.scope_value.call.human_attribute_name(self.name)
    end.call
  rescue
    Rails.logger.warn "Datagrid Patch ERROR: #{$!}"
  ensure
    header_original
  end
end

class Datagrid::Renderer

end