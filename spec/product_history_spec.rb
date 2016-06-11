require "rails_helper"
require "csv"

describe ProductHistory do

  before :each do
    File.open(Rails.root.join("spec/support/sample_csv_data.csv")) do |file|
      @file = file
    end
  end

  it "takes a csv file and create a records by reading it" do
    products = ProductHistory.create_from_file(@file, true)
    expect(products.length).to eq(4)

    # create without override, will add 4 more rows
    ProductHistory.create_from_file(@file, false)
    expect(ProductHistory.all.length).to eq(8)

    # create again with override, should delete previous records
    products = ProductHistory.create_from_file(@file, true)
    expect(products.length).to eq(4)
  end

  it "takes id, type and timestamp and gives back objects state at the given time" do
    ProductHistory.create_from_file(@file, true)

    # exactly at 412351252
    product = ProductHistory.get_historical_data(1, "ObjectA", 412351252)
    puts product.inspect
    expect(product.attribute_changes["property1"]).to eq("value1")
    expect(product.attribute_changes["property3"]).to eq("value2")

    # few seconds after 412351252
    product = ProductHistory.get_historical_data(1, "ObjectA", 412351300)
    expect(product.attribute_changes["property1"]).to eq("value1")
    expect(product.attribute_changes["property3"]).to eq("value2")

    product = ProductHistory.get_historical_data(1, "ObjectA", 0)
    expect(product.blank?).to eq(true)
  end

end