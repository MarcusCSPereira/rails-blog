# frozen_string_literal: true

class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :category

  has_one_attached :cover_image do |attachable|
    attachable.variant(:thumb, resize_to_limit: [325, 205])
    attachable.variant(:cover, resize_to_limit: [200, 200])
  end
end
