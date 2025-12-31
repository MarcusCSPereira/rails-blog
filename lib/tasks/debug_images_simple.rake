# frozen_string_literal: true

namespace :debug do
  desc "Debug simples - testar variante de uma imagem específica (sem banco)"
  task :test_variant_simple, [:blob_key] => :environment do |t, args|
    blob_key = args[:blob_key]

    unless blob_key
      puts "Uso: rails debug:test_variant_simple[BLOB_KEY]"
      puts "\nPara obter o blob_key, inspecione a tag <img> no browser:"
      puts "  - Abra DevTools (F12)"
      puts "  - Encontre a tag <img> da imagem"
      puts "  - O blob_key está na URL, exemplo:"
      puts "    /rails/active_storage/blobs/.../BLOB_KEY/..."
      next
    end

    puts "Testando blob_key: #{blob_key}"

    begin
      blob = ActiveStorage::Blob.find_by(key: blob_key)

      unless blob
        puts "❌ Blob não encontrado com key: #{blob_key}"
        next
      end

      puts "✅ Blob encontrado:"
      puts "   Filename: #{blob.filename}"
      puts "   Content Type: #{blob.content_type}"
      puts "   Byte Size: #{blob.byte_size}"

      # Verificar se arquivo existe
      if blob.service.exist?(blob.key)
        puts "   ✅ Arquivo existe no storage"
      else
        puts "   ❌ Arquivo NÃO existe no storage!"
      end

      # Testar variante medium
      puts "\nTestando variante :medium..."
      begin
        variant = blob.variant(resize_to_limit: [850, 650])
        puts "✅ Variante criada: #{variant.class}"

        url = begin
          variant.url
        rescue
          nil
        end
        if url
          puts "✅ URL gerada: #{url}"
        else
          puts "❌ Não foi possível gerar URL"
        end

        # Verificar se foi processada
        if variant.respond_to?(:processed?) && variant.processed?
          puts "✅ Variante já processada"
        else
          puts "⚠️  Variante será processada sob demanda"
        end
      rescue => e
        puts "❌ Erro ao criar variante: #{e.message}"
        puts "   Classe: #{e.class}"
        puts e.backtrace.first(3).join("\n")
      end
    rescue => e
      puts "❌ Erro: #{e.message}"
      puts e.backtrace.first(3).join("\n")
    end
  end
end
