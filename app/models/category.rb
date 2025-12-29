# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :articles, dependent: :nullify

  has_one_attached :cover_image do |attachable|
    attachable.variant(:thumb, resize_to_limit: [325, 205])
  end
end
