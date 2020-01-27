class RecordedRoomsService
  require 'json'
  attr_reader :abnb_user_id

  def initialize(abnb_user_id)
    @abnb_user_id = abnb_user_id    
  end

  def record
    service = PostedRoomsService.new(abnb_user_id)
    service.listing.each do |listed_room|
      create_snapshoted_room(listed_room)
    end
  end

  def create_snapshoted_room(listed_room)
    room = SnapshotedRoom.new
    room.name = listed_room["name"]
    room.ab_room_id = listed_room["room_id"]
    room.ab_user_id = listed_room["user_id"]
    room.snapshot_data = listed_room
    room.localized_city = listed_room["localized_city"]
    room.save
  end
end
