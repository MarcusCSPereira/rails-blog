# frozen_string_literal: true

namespace :debug do
  desc "Debug Active Storage images and variants"
  task images: :environment do
    puts "=" * 80
    puts "DEBUG: Active Storage Images"
    puts "=" * 80

    # Verificar configuração
    puts "\n1. Configuração do Active Storage:"
    puts "   Service: #{Rails.application.config.active_storage.service}"
    puts "   Variant Processor: #{Rails.application.config.active_storage.variant_processor}"
    puts "   Resolve Model to Route: #{Rails.application.config.active_storage.resolve_model_to_route}"

    # Verificar ImageMagick
    puts "\n2. Verificando ImageMagick:"
    begin
      result = %x(which convert).strip
      if result.present?
        puts "   ✅ ImageMagick encontrado: #{result}"
        version = %x(convert --version).split("\n").first
        puts "   Versão: #{version}"
      else
        puts "   ❌ ImageMagick NÃO encontrado!"
      end
    rescue => e
      puts "   ❌ Erro ao verificar ImageMagick: #{e.message}"
    end

    # Verificar artigos com imagens
    puts "\n3. Artigos com imagens anexadas:"
    articles_with_images = Article.joins("INNER JOIN active_storage_attachments ON active_storage_attachments.record_id = articles.id AND active_storage_attachments.record_type = 'Article' AND active_storage_attachments.name = 'cover_image'")

    if articles_with_images.any?
      articles_with_images.limit(5).each do |article|
        puts "\n   Artigo ID: #{article.id}"
        puts "   Título: #{article.title}"

        if article.cover_image.attached?
          blob = article.cover_image.blob
          puts "   ✅ Imagem anexada:"
          puts "      - Filename: #{blob.filename}"
          puts "      - Content Type: #{blob.content_type}"
          puts "      - Byte Size: #{blob.byte_size}"
          puts "      - Key: #{blob.key}"
          puts "      - Service Name: #{blob.service_name}"

          # Verificar se arquivo existe
          if blob.service.exist?(blob.key)
            puts "      ✅ Arquivo existe no storage"
          else
            puts "      ❌ Arquivo NÃO existe no storage!"
          end

          # Testar variantes
          puts "\n   Testando variantes:"
          [:thumb, :cover, :medium].each do |variant_name|
            variant = article.cover_image.variant(variant_name)
            puts "      - #{variant_name}: ✅ Variante criada"
            puts "        URL: #{begin
              variant.url
            rescue
              "N/A"
            end}"

            # Verificar se variante foi processada
            if variant.processed?
              puts "        ✅ Variante processada"
            else
              puts "        ⚠️  Variante ainda não processada (será processada sob demanda)"
            end
          rescue => e
            puts "      - #{variant_name}: ❌ Erro: #{e.message}"
            puts "        Classe: #{e.class}"
          end
        else
          puts "   ❌ Nenhuma imagem anexada"
        end
      end
    else
      puts "   ⚠️  Nenhum artigo com imagem encontrado"
    end

    # Verificar diretório storage
    puts "\n4. Verificando diretório storage:"
    storage_path = Rails.root.join("storage")
    if storage_path.exist?
      puts "   ✅ Diretório existe: #{storage_path}"
      puts "   Permissões: #{File.stat(storage_path).mode.to_s(8)}"

      # Contar arquivos
      files = Dir.glob(storage_path.join("**/*")).select { |f| File.file?(f) }
      puts "   Arquivos encontrados: #{files.count}"
    else
      puts "   ❌ Diretório não existe: #{storage_path}"
    end

    puts "\n" + "=" * 80
  end

  desc "Testar processamento de variante específica"
  task :test_variant, [:article_id, :variant_name] => :environment do |t, args|
    article_id = args[:article_id] || Article.first&.id
    variant_name = (args[:variant_name] || :medium).to_sym

    unless article_id
      puts "❌ Nenhum artigo encontrado"
      next
    end

    article = Article.find(article_id)
    puts "Testando variante #{variant_name} para artigo: #{article.title}"

    if article.cover_image.attached?
      begin
        variant = article.cover_image.variant(variant_name)
        puts "✅ Variante criada: #{variant.class}"
        puts "URL: #{begin
          variant.url
        rescue
          "N/A"
        end}"

        # Forçar processamento
        puts "\nForçando processamento..."
        processed = variant.processed
        puts "Processado: #{processed}"

        if processed
          puts "✅ Variante processada com sucesso!"
        else
          puts "⚠️  Variante será processada sob demanda"
        end
      rescue => e
        puts "❌ Erro: #{e.message}"
        puts e.backtrace.first(5).join("\n")
      end
    else
      puts "❌ Artigo não tem imagem anexada"
    end
  end
end
