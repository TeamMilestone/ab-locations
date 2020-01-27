require 'test_helper'

class PostedRoomsServiceTest < ActiveSupport::TestCase
  setup do

  end

  test "특정 호스트의 전체 방 정보 가져오기" do  
    abnb_user_id = 121759778
    service = PostedRoomsService.new(abnb_user_id)
    puts service.listing.map{ |x| x["name"] }
  end
end
