# frozen_string_literal: true

FactoryBot.define do
  factory :preview_options, class: Hash do
    enable_preview_mode false
    preview_through_term_end false

    initialize_with { attributes }
  end
end
