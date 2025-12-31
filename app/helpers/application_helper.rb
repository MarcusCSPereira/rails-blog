# frozen_string_literal: true

module ApplicationHelper
  def cover_image_fallback(article, variant = :thumb)
    raise ArgumentError, "Esperado Article, recebido #{article.class}" unless article.is_a?(Article)

    if article.cover_image.attached?
      begin
        # No Rails 8, variantes definidas no model podem ser acessadas diretamente
        variant_obj = article.cover_image.variant(variant)

        # Debug: Logar informações em desenvolvimento
        if Rails.env.development?
          Rails.logger.debug("Variante #{variant} criada para artigo #{article.id}: #{variant_obj.class}")
          Rails.logger.debug("URL: #{begin
            variant_obj.url
          rescue
            "N/A"
          end}")
        end

        # Em produção, pode ser necessário processar a variante explicitamente
        # O Rails processa sob demanda, mas podemos forçar se necessário
        variant_obj
      rescue => e
        # Em caso de erro, logar e retornar imagem original
        Rails.logger.error("Erro ao processar variante #{variant} para artigo #{article.id}: #{e.message}")
        Rails.logger.error(e.backtrace.first(5).join("\n")) if Rails.env.development?

        # Retornar imagem original como fallback
        article.cover_image
      end
    else
      "posts/post1.jpg"
    end
  end
end
