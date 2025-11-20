# frozen_string_literal: true

module WelcomeHelper
  def cover_image_fallback(article)
    raise ArgumentError, "Esperado Article, recebido #{article.class}" unless article.is_a?(Article)

    if article.cover_image.attached?
      article.cover_image.variant(:thumb)
    else
      "posts/post1.jpg"
    end
  end
end
