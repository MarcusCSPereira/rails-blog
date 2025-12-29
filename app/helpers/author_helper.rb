# frozen_string_literal: true

module AuthorHelper
  def avatar_image_fallback(author)
    raise ArgumentError, "Esperado Author, recebido #{author.class}" unless author.is_a?(Author)

    if author.avatar_image.attached?
      author.avatar_image.variant(:thumb)
    else
      "avatar/man-1.svg"
    end
  end
end
