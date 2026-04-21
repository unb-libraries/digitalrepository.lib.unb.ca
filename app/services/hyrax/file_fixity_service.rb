module Hyrax
  class FileFixityService
    extend ActiveSupport::Concern

    def create_checksum(file_id)
      # TODO: implement real checksum creation
      "89d97604b7bd2889826c2791af076b04"
    end
  end
end
