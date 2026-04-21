namespace :fixity do
  desc "Fixity check everything"
  task check: :environment do
    Rails.logger.info "Performing fixity check"
    Hyrax.query_service.find_all_of_model(model: Hyrax::FileSet).each_slice(1000) do |slice|
      slice.each do |fs|
        Hyrax::FileSetFixityCheckService.new(fs).fixity_check
      end
    end
  end
end
