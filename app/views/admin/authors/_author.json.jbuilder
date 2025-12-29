# frozen_string_literal: true

json.extract!(author, :id, :name, :description, :avatar_image, :youtube_profile_url, :facebook_profile_url, :instagram_profile_url, :twitter_profile_url, :linkedin_profile_url, :created_at, :updated_at)
json.url(author(author, format: :json))
