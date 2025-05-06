# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work_resource Book`
class Book < Hyrax::Work
  include Hyrax::Schema(:basic_metadata)
  include Hyrax::Schema(:book)
end
