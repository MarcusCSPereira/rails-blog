# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :articles, dependent: :destroy

  has_one_attached :avatar_image do |attachable|
    attachable.variant(:thumb, resize_to_limit: [165, 165])
  end
end
