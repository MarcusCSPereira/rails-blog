# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  has_many :comment_like_dislikes, dependent: :destroy

  validates :body, presence: true
end
