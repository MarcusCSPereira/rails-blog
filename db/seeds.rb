# frozen_string_literal: true

admins = ["admin@admin.com", "test@test.com"]

admins.each do |email|
  AdminUser.find_or_create_by!(email: email) do |admin|
    admin.password = ENV["DEFAULT_PASSWORD"]
    admin.password_confirmation = ENV["DEFAULT_PASSWORD"]
  end
end
