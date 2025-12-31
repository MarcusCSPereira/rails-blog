# frozen_string_literal: true

module ApplicationHelper
  def cover_image_fallback(article, variant = :thumb)
    raise ArgumentError, "Esperado Article, recebido #{article.class}" unless article.is_a?(Article)

    if article.cover_image.attached?
      begin
        article.cover_image.variant(variant)
      rescue => e
        Rails.logger.error("Erro ao processar variante #{variant} para artigo #{article.id}: #{e.message}")
        article.cover_image
      end
    else
      "posts/post1.jpg"
    end
  end
end
