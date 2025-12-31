# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_footer_data, if: :devise_users_controller?
  before_action :store_user_location!, if: :storable_location?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || super
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referer if resource_or_scope == :user
  end

  def devise_users_controller?
    return false unless devise_controller?

    # Verifica se o path começa com /users/ (rotas do Devise para users)
    request.path.start_with?("/users/") || request.path.start_with?("/admin_users/")
  end

  def set_footer_data
    @recent_categories_footer = Category.order(created_at: :desc).limit(8)
    @recent_articles_footer = Article.includes(:author, :category).with_attached_cover_image.order(updated_at: :desc).limit(4)
  end
end
