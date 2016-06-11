require 'csv'
require 'json'
class ProductHistory < ActiveRecord::Base
  extend Common
  serialize :attribute_changes, Hash

  def self.create_from_file(csv_file, override_flag = false)
    headers = []
    product_ids = []
    product_types = []
    history_rows = []
    products = []

    CSV.foreach(csv_file) do |row|
      if headers.length > 0
        history_rows << {
            product_id: row[0],
            product_type: row[1],
            unix_ts: row[2],
            attribute_changes: JSON.parse(row[3])
        }

        product_ids << row[0]
        product_types << row[1]
      else
        headers.push(*row)
      end
    end

    csv_file.close if csv_file && !csv_file.closed?

    ActiveRecord::Base.transaction do
      if override_flag
        delete_all({product_id: product_ids.uniq, product_type: product_types.uniq}) #TODO: check why destroy_all is giving syntax error in PG
      end

      products = create(history_rows)
    end

    products #return
  end

  def self.get_historical_data(id, product_type, timestamp)
    result = {}
    products = where("product_id = ? and product_type = ? and unix_ts <= ?", id, product_type, timestamp).order("unix_ts DESC")

    if products.present?
      latest = products.first
      latest_attribute = latest.attribute_changes
      attributes = {}

      for i in 1..products.length-1
        attributes = attributes.merge(products[i].attribute_changes)
        attributes = attributes.merge(latest_attribute)
      end

      latest.attribute_changes = attributes unless attributes.blank?

      result = latest
    end

    result #return value
  end
end
