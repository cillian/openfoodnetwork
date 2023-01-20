# frozen_string_literal: true

require "spec_helper"

describe "spree/admin/shared/_order_links.html.haml" do
  helper Spree::BaseHelper # required to make pretty_time work
  helper Spree::Admin::OrdersHelper

  before do
    order = create(:order)
    assign(:order, order)
  end

  describe "actions dropdown" do
    it "contains all the actions buttons" do
      render

      expect(rendered).to have_content("Edit Order")
    end
  end
end
