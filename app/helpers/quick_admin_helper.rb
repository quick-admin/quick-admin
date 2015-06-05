#
module QuickAdminHelper
  def item(object, attribute = nil, link: nil, &block)
    if block_given?
      text = block.call(object)
    else
      value = object.try(attribute) if attribute
      text = item_value(object, attribute, value, link: link)
    end

    label =
      if object.class.respond_to?(:human_attribute_name)
        object.class.human_attribute_name attribute
      else
        attribute
      end

    render \
      partial: 'quick_admin/item',
      locals: {
        value: text, label: label,
        object: object, attribute: attribute
      }
  end

  def item_value(object, attribute, value = nil, options = {})
    value = object.send(attribute) unless value
    case
    when attribute =~ /(.+)_id/ && object.respond_to?($1)
      link_model object.send($1)
    when object.class.respond_to?(:members) && object.class.members.include?(attribute.to_s)
      [value].flatten.select { |val| !val.blank? }
        .map { |val| object.class.human_member_name(attribute, val) }.join(', ')
    else
      human_value value, options
    end
  end

  def human_value(value, options = {})
    raw_text =
      case value
      when ActiveRecord::Base
        link_model(value)
      when DateTime, Time
        l value, format: :short
      when ActiveSupport::TimeWithZone
        l value.to_time, format: :short
      when Date
        l value, format: :short
      when Array
        value.map { |val| human_value(val) }
        .reject(&:blank?).join(', ')
      when TrueClass, FalseClass
        t value.to_s
      else
        value
      end

    case
    when !options[:link].blank?
      link_to truncate(raw_text), options[:link]
    when value.nil?
      content_tag :span, '<empty>', class: 'empty'
    else
      raw_text
    end
  end

  def items(object, *attributes, &block)
    options = attributes.extract_options!
    inner = block.call if block_given?
    options.merge! class: "ui list #{options[:class]}"
    content_tag :div, options do
      nodes = attributes.map { |attr| item(object, attr) }
      [nodes, inner].flatten.compact.join.html_safe
    end
  end

  def default_item_names(object, columns = 2)
    names = object.class.column_names
    size = (names.size + 1) / columns
    0.upto(columns - 1).map { |n| names[(n * size)..((n + 1) * size - 1)] }
  end

  # 显示model名称
  # * 以display_name, name, to_s 判断model的显示名称
  def display(object)
    text =
      case
      when object.respond_to?(:display_name)
        object.display_name
      when object.respond_to?(:human)
        object.human
      when object.respond_to?(:name)
        object.name
      else
        object.to_s
      end
    sanitize markdown(text), tags: %w(span code strong abbr)
  rescue
    $ERROR_INFO.message
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    raw @markdown.render(content.to_s)
  end

  # 自动连接model
  # * 以display_name, name, to_s 判断model的显示名称
  # * 如果有 model_name_path 的路由则进行超链接
  def link_model(value)
    return unless value
    display = display(value)
    path =
      "#{ActiveModel::Naming.singular_route_key(value)}_path"
    if value.is_a?(ActiveRecord::Base) && respond_to?(path)
      link_to display, value
    else
      display
    end
  end

  #override
  def link_to(name = nil, options = nil, html_options = nil, &block)
    return super unless options.is_a?(ActiveRecord::Base)
    path =
      "#{ActiveModel::Naming.singular_route_key(options)}_path"
    return link_to name, send(path, options) if respond_to?(path)
    superclass = options.class.superclass
    path = "#{ActiveModel::Naming.singular_route_key(superclass)}_path"
    return link_to name, send(path, options) if respond_to?(path)
    super
  end
  # 对show页面显示actions动作面板
  def show_action(*actions)
    deny_actions =
      (actions.map!(&:to_s)) - %w(new back edit destroy)
    fail 'only allow new, back, edit and destory' unless deny_actions.empty?

    render\
      partial: 'quick_admin/action_show',
      locals: { actions: actions }
  end
end
