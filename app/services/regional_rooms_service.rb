class RegionalRoomsService
  require 'json'
  attr_reader :url, :parsed_response, :api_key, :list_count

  def initialize(url)
    @url = url
    @base_url = base_url
    @parsed_response = body
    # @list_count = list_count
    # @api_key = api_key    
  end

  def base_url
    url
  end

  def listing_url(offset)
    listing_base_url = "https://www.airbnb.co.kr/api/v2/user_promo_listings?_limit=10&currency=KRW&locale=ko"
    base_url_with_offset = "#{listing_base_url}&_offset=#{offset}"
    listing_url = "#{base_url_with_offset}&key=#{api_key}&user_id=#{abnb_user_id}"
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
    # bootstrap_data = parsed_hash["bootstrapData"]
    # bootstrap_data
  end

  def user_hash
    data_state_hash["reduxData"]["bootstrapLoad"]["user"]
  end

  def api_key
    data_state_hash["layout-init"]["api_config"]["key"]
  end

  def first_ten_listing
    listing_data = data_state_hash["reduxData"]["bootstrapLoad"]["listingData"]
    listing_data["user_promo_listings"]
  end

  def next_ten_listing(offset=10)
    request_url = listing_url(offset)    
    uri = URI.parse(request_url)
    response = Net::HTTP.get_response(uri)    
    raw_json = response.body
    parsed_hash = JSON.parse(raw_json)
    parsed_hash["user_promo_listings"]
  end

  def listing
    list = first_ten_listing    
    offset_ten = list_count / 10    
    offset_ten.times do |i|
      offset = (i + 1) * 10
      list += next_ten_listing(offset)
    end
    list
  end

  def list_count
    listing_data = data_state_hash["reduxData"]["bootstrapLoad"]["listingData"]
    listing_data["metadata"]["record_count"]
  end
end
