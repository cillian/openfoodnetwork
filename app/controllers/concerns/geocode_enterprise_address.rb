# frozen_string_literal: true

module GeocodeEnterpriseAddress
  extend ActiveSupport::Concern

  def geocode_address_if_use_geocoder
    return unless @use_geocoder

    AddressGeocoder.new(@enterprise.address).geocode
  end

  def store_and_delete_use_geocoder_parameter
    @use_geocoder = (
      params.dig(:enterprise, :address_attributes) || {}
    ).delete(:use_geocoder) == "1"
  end
end
