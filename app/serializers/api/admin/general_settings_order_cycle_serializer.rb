# frozen_string_literal: true

module Api
  module Admin
    class GeneralSettingsOrderCycleSerializer < ActiveModel::Serializer
      attributes :id, :name, :orders_open_at, :orders_close_at, :coordinator_id,
                 :viewing_as_coordinator, :schedule_ids, :subscriptions_count

      has_many :coordinator_fees, serializer: Api::IdSerializer

      def orders_open_at
        object.orders_open_at.to_s
      end

      def orders_close_at
        object.orders_close_at.to_s
      end

      def viewing_as_coordinator
        Enterprise.managed_by(options[:current_user]).include? object.coordinator
      end

      def subscriptions_count
        ProxyOrder.not_canceled.where(order_cycle_id: object.id).count
      end
    end
  end
end
