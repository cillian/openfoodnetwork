# frozen_string_literal: true

module Spree
  module Admin
    module OrdersHelper
      def event_links
        links = []
        links << cancel_event_link if @order.can_cancel?
        links << resume_event_link if @order.can_resume?
        links.join('&nbsp;').html_safe
      end

      def line_item_shipment_price(line_item, quantity)
        Spree::Money.new(line_item.price * quantity, currency: line_item.currency)
      end

      def order_links(order)
        @order ||= order
        links = []
        links << edit_order_link unless action_name == "edit"
        links.concat(complete_order_links) if @order.complete? || @order.resumed?
        links << ship_order_link if @order.ready_to_ship?
        links << cancel_order_link if @order.can_cancel?
        links.each { |link| link[:attributes]["data-action"] = "click->dropdown#close" }
        links
      end

      private

      def complete_order_links
        [resend_confirmation_link] + invoice_links + ticket_links
      end

      def invoice_links
        return [] unless Spree::Config[:enable_invoices?]

        [send_invoice_link, print_invoice_link]
      end

      def send_invoice_link
        if @order.distributor.can_invoice?
          send_invoice_link_with_url
        else
          send_invoice_link_without_url
        end
      end

      def print_invoice_link
        if @order.distributor.can_invoice?
          print_invoice_link_with_url
        else
          notify_about_required_enterprise_number
        end
      end

      def ticket_links
        return [] unless Spree::Config[:enable_receipt_printing?]

        [print_ticket_link, select_ticket_printer_link]
      end

      def edit_order_link
        {
          name: t(:edit_order),
          icon: 'icon-edit',
          attributes: {
            href: spree.edit_admin_order_path(@order),
          }
        }
      end

      def resend_confirmation_link
        {
          name: t(:resend_confirmation),
          icon: 'icon-email',
          attributes: {
            href: spree.resend_admin_order_path(@order),
            data: {
              method: 'post',
              confirm: t(:confirm_resend_order_confirmation)
            }
          }
        }
      end

      def send_invoice_link_with_url
        {
          name: t(:send_invoice),
          icon: 'icon-email',
          attributes: {
            href: invoice_admin_order_path(@order),
            data: { confirm: t(:confirm_send_invoice) }
          }
        }
      end

      def send_invoice_link_without_url
        {
          name: t(:send_invoice),
          icon: 'icon-email',
          attributes: {
            href: "#",
            data: { confirm: t(:must_have_valid_business_number, enterprise_name: @order.distributor.name) }
          }
        }
      end

      def print_invoice_link_with_url
        {
          name: t(:print_invoice),
          icon: 'icon-print',
          attributes: {
            href: spree.print_admin_order_path(@order),
            target: "_blank"
          }
        }
      end

      def notify_about_required_enterprise_number
        {
          name: t(:print_invoice),
          icon: 'icon-print',
          attributes: {
            href: "#",
            data: { confirm: t(:must_have_valid_business_number, enterprise_name: @order.distributor.name) }
          }
        }
      end

      def print_ticket_link
        {
          name: t(:print_ticket),
          icon: 'icon-print',
          attributes: {
            href: print_ticket_admin_order_path(@order),
            target: "_blank"
          }
        }
      end

      def select_ticket_printer_link
        {
          name: t(:select_ticket_printer),
          icon: 'icon-print',
          attributes: {
            href: "#{print_ticket_admin_order_path(@order)}#select-printer",
            target: "_blank"
          }
        }
      end

      def ship_order_link
        {
          name: t(:ship_order),
          icon: 'icon-truck',
          attributes: {
            href: spree.fire_admin_order_path(@order, e: 'ship'),
            data: {
              method: 'put',
              confirm: t(:are_you_sure)
            }
          }
        }
      end

      def cancel_order_link
        {
          name: t(:cancel_order),
          icon: 'icon-trash',
          attributes: {
            href: spree.fire_admin_order_path(@order.number, e: 'cancel'),
            data: { confirm: t(:are_you_sure) }
          }
        }
      end

      def cancel_event_link
        event_label = I18n.t("cancel", scope: "actions")
        button_link_to(event_label,
                       fire_admin_order_url(@order, e: "cancel"),
                       method: :put, icon: "icon-remove", form_id: "cancel_order_form")
      end

      def resume_event_link
        event_label = I18n.t("resume", scope: "actions")
        confirm_message = I18n.t("admin.orders.edit.order_sure_want_to", event: event_label)
        button_link_to(event_label,
                       fire_admin_order_url(@order, e: "resume"),
                       method: :put, icon: "icon-resume",
                       data: { confirm: confirm_message })
      end

      def quantity_field_tag(manifest_item)
        html_options = { min: 0, class: "line_item_quantity", size: 5 }
        unless manifest_item.variant.on_demand
          html_options.merge!(max: manifest_item.variant.on_hand + manifest_item.quantity)
        end
        number_field_tag :quantity, manifest_item.quantity, html_options
      end
    end
  end
end
