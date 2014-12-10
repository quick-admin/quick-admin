require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  it :default_item_names do

    model_class = double(:model_class, column_names: %W(a b c))
    model = double(:model, class: model_class)
    expect(default_item_names(model)).not_to be_nil
  end
end