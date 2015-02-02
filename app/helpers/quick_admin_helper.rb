module QuickAdminHelper


  def item object, attribute=nil, link: nil, &block
    if block_given?
      text = block.call(object) 
    else
      value = object.try(attribute) if attribute
      text = item_value(object, attribute, value, link: link)
    end

    label = object.class.try(:human_attribute_name, attribute) rescue attribute

    render partial: 'quick_admin/item', locals: {value: text, label: label, object: object, attribute: attribute}

  end

  def item_value object, attribute, value, link: nil
    text = case value
    when ActiveRecord::Base
      link_model(value)
    when DateTime, Time, ActiveSupport::TimeWithZone
      time_ago_in_words value
    when Date
      l value
    when Array
      value.map{|val| item_value(object, attribute, val)}.select{|i|!i.blank?}.join(", ")
    when TrueClass, FalseClass
      t value.to_s
    else
      case
      when !link.blank?
        link_to truncate(value.to_s), link
      when object.class.respond_to?(:members) && object.class.members.include?(attribute.to_s)
        [value].flatten.select{|val|!val.blank?}
          .map{|val|object.class.human_member_name(attribute, val)}.join(", ")
      else
        value.respond_to?(:human) ? value.human : value
      end
    end
    markdown text
  end

  # 创建resource关于attributes的属性Define List
  def items object, *attributes, &block
    options = attributes.extract_options!
    inner = block.call if block_given?
    content_tag :dl, options do
      nodes = attributes.map{|attr| item(object, attr)}
      [nodes, inner].flatten.compact.join.html_safe
    end
  end

  def default_item_names object, columns=2
    names = object.class.column_names
    size = (names.size + 1) / columns
    0.upto(columns-1).map{|n| names[(n*size)..((n+1)*size-1)]}
  end

  # 显示model名称
  # * 以display_name, name, to_s 判断model的显示名称
  def display object
    text = case
    when object.respond_to?(:display_name)
      object.display_name
    when object.respond_to?(:human)
      object.human
    when object.respond_to?(:name)
      object.name
    else
      object.to_s
    end
    markdown text
  rescue
    logger.warn "#{$!}: #{$!.backtrace()}"
    "!E"
  end

  def markdown content
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    raw @markdown.render(content.to_s||"")
  end

  # 自动连接model
  # * 以display_name, name, to_s 判断model的显示名称
  # * 如果有 model_name_path 的路由则进行超链接
  def link_model value
    display = display(value)

    if value.is_a?(ActiveRecord::Base) && respond_to?("#{ActiveModel::Naming.singular_route_key(value)}_path")
      link_to display, value
    else
      display
    end
  end

  # 对show页面显示actions动作面板
  def show_action *actions

    raise "only allow new, back, edit and destory" unless ((actions.map!(&:to_s)) - %W(new back edit destroy)).size == 0 

    render partial: 'quick_admin/action_show', locals: {actions: actions} 
  end

end
