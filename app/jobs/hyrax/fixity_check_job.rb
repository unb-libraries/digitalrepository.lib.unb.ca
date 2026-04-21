# frozen_string_literal: true

module Hyrax
  class FixityCheckJob < Hyrax::ApplicationJob
    # A Job class that runs a fixity check (using Hyrax.config.fixity_service)
    # and stores the results in an ActiveRecord ChecksumAuditLog row. It also prunes
    # old ChecksumAuditLog rows after creating a new one, to keep old ones you don't
    # care about from filling up your db.
    #
    # The file_set_id and file_id are used only for logging context in the
    # ChecksumAuditLog, and determining what old ChecksumAuditLogs can
    # be pruned.
    #
    # If calling async as a background job, return value is irrelevant, but
    # if calling sync with `perform_now`, returns the ChecksumAuditLog
    # record recording the check.
    #
    # @param uri [String] uri - of the specific file/version to fixity check
    # @param file_set_id [FileSet] the id for FileSet parent object of URI being checked.
    # @param file_id [String] File#id, used for logging/reporting.
    def perform(uri, file_set_id:, file_id:)
      run_check(file_set_id, file_id, uri).tap do |audit|
        result   = audit.failed? ? :failure : :success
        file_set = Hyrax.query_service.find_by(id: file_set_id)

        Hyrax.publisher.publish("file.set.audited", file_set: file_set, audit_log: audit, result: result)

        # @todo remove this callback call for Hyrax 4.0.0
        if audit.failed? && Hyrax.config.callback.set?(:after_fixity_check_failure)
          Hyrax.config.callback.run(:after_fixity_check_failure,
                                    file_set,
                                    checksum_audit_log: audit, warn: false)
        end
      end
    end

    private

    ##
    # @api private
    def run_check(file_set_id, file_id, uri)
      service = Hyrax::FileFixityService.new

      latest_fixity_check = ChecksumAuditLog.logs_for(file_set_id, checked_uri: uri).first
      expected_result = latest_fixity_check.expected_result if latest_fixity_check.present?
      actual_result = service.create_checksum(file_id)
      expected_result = actual_result unless expected_result
      passed = actual_result == expected_result

      ChecksumAuditLog.create_and_prune!(passed: passed, file_set_id: file_set_id, checked_uri: uri.to_s, file_id: file_id, expected_result: expected_result)
    rescue Hyrax::Fixity::MissingContentError
      ChecksumAuditLog.create_and_prune!(passed: false, file_set_id: file_set_id, checked_uri: uri.to_s, file_id: file_id, expected_result: expected_result)
    end
  end
end
