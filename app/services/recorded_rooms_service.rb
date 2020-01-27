class RecordedRoomsService
  require 'json'
  attr_reader :abnb_user_id

  def initialize(abnb_user_id)
    @abnb_user_id = abnb_user_id    
  end

  def record
    service = PostedRoomsService.new(abnb_user_id)
    listing = service.listing
    listing.each do |listed_room|
      create_snapshoted_room(listed_room)
    end
    listing.map{ |x| x["id"] }
  end

  def create_snapshoted_room(listed_room)    
    room = SnapshotedRoom.new
    if SnapshotedRoom.where(ab_room_id: listed_room["id"]).exists?
      room = SnapshotedRoom.where(ab_room_id: listed_room["id"]).first
    end
    room.name = listed_room["name"]
    room.ab_room_id = listed_room["id"]
    user_id = listed_room["user_id"]
    user_id = abnb_user_id unless user_id.present?
    room.ab_user_id = user_id
    room.snapshot_data = listed_room
    room.bedrooms = listed_room["bedrooms"]
    room.localized_city = listed_room["localized_city"]
    room.save!
  end
end
