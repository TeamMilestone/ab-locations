require 'test_helper'

class RecordedRoomsServiceTest < ActiveSupport::TestCase
  setup do

  end

  test "특정 호스트의 전체 방 정보 저장하기" do  
    abnb_user_id = 121759778
    service = RecordedRoomsService.new(abnb_user_id)
    service.record
  end
end
