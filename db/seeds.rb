# frozen_string_literal: true

admins = {
  "admin@admin.com" => "admin",
  "test@test.com" => "test",
}

admins.each do |email, name|
  AdminUser.find_or_create_by!(email: email, name: name) do |admin|
    admin.password = ENV["DEFAULT_PASSWORD"]
    admin.password_confirmation = ENV["DEFAULT_PASSWORD"]
  end
end
