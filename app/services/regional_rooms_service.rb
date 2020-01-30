class RegionalRoomsService
  require "json"
  attr_reader :url, :parsed_response, :api_key, :list_count

  def initialize(url)
    @url = url
    @base_url = base_url
    @parsed_response = body
    @list_count = list_count
    @api_key = api_key
  end

  def base_url
    url
  end

  def location_query
    params = data_state_hash["reduxData"]["exploreTab"]["requestFilters"]
    "#{Rack::Utils.build_query(params)}&key=#{api_key}"
  end

  def listing_url(offset)
    listing_base_url = "https://www.airbnb.co.kr/api/v2/explore_tabs"
    listing_url = "#{listing_base_url}?#{location_query}&items_offset=#{offset}"
    listing_url
  end

  def body
    request_url = "#{@base_url}"
    uri = URI.parse(request_url)
    response = Net::HTTP.get_response(uri)
    parsed_response = Nokogiri::HTML(response.body)
    parsed_response
  end

  def data_state_hash
    raw_json = parsed_response.xpath('//*[@id="data-state"]').text
    parsed_hash = JSON.parse(raw_json)
    bootstrap_data = parsed_hash["bootstrapData"]
    bootstrap_data
  end

  def api_key
    data_state_hash["layout-init"]["api_config"]["key"]
  end

  def first_listing
    listing_data = data_state_hash["reduxData"]["exploreTab"]["response"]
    listing_data["explore_tabs"][0]["sections"][0]["listings"]
  end

  def next_listing(offset = 18)
    request_url = listing_url(offset)
    uri = URI.parse(request_url)
    response = Net::HTTP.get_response(uri)
    raw_json = response.body
    parsed_hash = JSON.parse(raw_json)
  end

  def next_listing_url_query
    next_listing["explore_tabs"][0]["pagination_metadata"]
  end

  def listing
    items_per_page = 18
    list = first_listing
    page_count = list_count / items_per_page
    page_count.times do |i|
      offset = (i + 1) * items_per_page
      list += next_listing(offset)
    end
    list
  end

  def list_count
    listing_data = data_state_hash["reduxData"]["exploreTab"]["response"]
    listing_data["explore_tabs"][0]["home_tab_metadata"]["listings_count"]
  end
end
