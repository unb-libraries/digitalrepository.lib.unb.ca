require "philiprehberger/checksum"

module Hyrax
  class FileFixityService
    extend ActiveSupport::Concern

    def create_checksum(file_id)
      # TODO: implement real checksum creation
      file = Hyrax.storage_adapter.find_by(id: file_id)
      Philiprehberger::Checksum.file_md5(file.io.path)
    end
  end
end
