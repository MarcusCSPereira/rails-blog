# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :comments, dependent: :destroy
  has_many :comment_like_dislikes, dependent: :destroy

  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable
end
