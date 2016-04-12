require 'rails_helper'
include InventoryExceptions
# these tests must be run in order and all at once
RSpec.describe Inventory, order: :defined, type: :model do
  let(:name) do
    name = ''
    name += (rand(26) + 65).chr until name.length > 120
    name
  end

  before :each do
    Timecop.freeze
  end

  after :each do
    Timecop.return
  end

  it 'tests the remote app' do
    response = nil

    item_type_uuid = nil
    # create item type
    expect { response = Inventory.create_item_type(name, ['fur type', 'height', 'cuddlyness']) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(item_type_uuid = response.try(:[], 'uuid')).not_to be_nil

    # get all item type
    expect { response = Inventory.item_types }.not_to raise_error
    expect(response).to be_a(Array)
    expect(response.count).not_to eq 0

    # get one item type
    expect { response = Inventory.item_type(item_type_uuid) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[], 'uuid')).to eq(item_type_uuid)
    expect(response.try(:[], 'name')).to eq(name)

    # update item type
    expect { response = Inventory.update_item_type(item_type_uuid, params = { allowed_keys: ['color'] }) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[], 'allowed_keys')).to eq(['color'])

    item_uuid = nil
    # creates item
    expect { response = Inventory.create_item(item_type_uuid, name, true, {}) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(item_uuid = response.try(:[], 'uuid')).not_to be_nil

    # get item by uuid
    expect { response = Inventory.item(item_uuid) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[], 'uuid')).to eq(item_uuid)

    # gets items by type
    expect { response = Inventory.items_by_type(item_type_uuid) }.not_to raise_error
    expect(response).to be_a(Array)
    expect(response).to include('name' => name, 'uuid' => item_uuid)

    item_name = name + 'a'
    # updates item
    expect { response = Inventory.update_item(item_uuid, name: item_name, data: { color: "red (becuase it's faster)" }) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[], 'name')).not_to be_nil
    expect(response.try(:[], 'name')).not_to eq(name)
    expect(response.try(:[], 'data')).not_to be_nil
    expect(response.try(:[], 'data')).to eq('color' => "red (becuase it's faster)")
    expect(response.try(:[], 'uuid')).to eq(item_uuid)

    reservation_uuid = nil
    # creates reservation
    expect { response = Inventory.create_reservation(name, Time.now, 6.days.from_now) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(reservation_uuid = response.try(:[], 'uuid')).not_to be_nil
    expect(response.try(:[], 'item_type')).to eq(name)
    expect(response.try(:[], 'item')).to eq(item_name)

    # get reservation
    expect { response = Inventory.reservation(reservation_uuid) }.not_to raise_error
    expect(response).to be_a(Hash)
    expect(response.try(:[], 'uuid')).to eq(reservation_uuid)

    # searches by time period
    expect { response = Inventory.reservations(Time.now, 7.days.from_now, name) }.not_to raise_error
    expect(response).to be_a(Array)
    expect(response).to include('start_time' => Time.now.iso8601, 'end_time' => 6.days.from_now.to_time.iso8601)

    # update reservation
    expect { response = Inventory.update_reservation(reservation_uuid, reservation: { start_time: (Time.now + 1.day) }) }.not_to raise_error
    expect(response).to be_a(Hash)
    time = nil
    expect(time = response.try(:[], 'start_time')).not_to be_nil
    expect(Time.parse(time)).to be_within(1.day).of(Time.now + 1.day)

    # updates reservation's metadata
    expect { response = Inventory.update_reservation_data(reservation_uuid, data: { color: 'orange' }) }.not_to raise_error
    expect(response).to be_nil

    # deletes item
    expect { response = Inventory.delete_item(item_uuid) }.not_to raise_error
    expect(response).to be_nil
    expect { Inventory.item(item_uuid) }.to raise_error ItemNotFound

    # delete item_type
    expect { response = Inventory.delete_item_type(item_type_uuid) }.not_to raise_error
    expect(response).to be_nil
    expect { Inventory.item_type(item_type_uuid) }.to raise_error ItemTypeNotFound

    # delete reservation
    expect { response = Inventory.delete_reservation(reservation_uuid) }.not_to raise_error
    expect(response).to be_nil
  end
end
