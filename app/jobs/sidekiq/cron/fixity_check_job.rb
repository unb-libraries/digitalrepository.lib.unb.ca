module Sidekiq
  module Cron
    class FixityCheckJob
      include Sidekiq::Worker

      def perform
        Hyrax.logger.info "Starting fixity check job"
        Hyrax.query_service.find_all_of_model(model: Hyrax::FileSet).each_slice(1000) do |slice|
          slice.each do |fs|
            Hyrax::FileSetFixityCheckService.new(fs, async_jobs: false, max_days_between_fixity_checks: -1).fixity_check
          end
        end
      end
    end
  end
end
