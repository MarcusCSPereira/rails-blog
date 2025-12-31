# frozen_string_literal: true

# Require tty-spinner apenas se disponível (não está no grupo production)
begin
  require "tty-spinner"
rescue LoadError
  # tty-spinner não disponível em produção, usar fallback simples
  module TTY
    class Spinner
      def initialize(msg, format: nil) = @msg = msg
      def auto_spin; end
      def success(msg) = puts("#{@msg} #{msg}")
    end
  end
end

namespace :dev do
  desc "Add the articles to the database"
  task add_articles: :environment do
    show_spinner("Adding articles to the database") { add_articles }
  end

  desc "Reset the database"
  task reset_db: :environment do
    show_spinner("Resetting the database") { reset_db }
  end

  desc "Add the categories to the database"
  task add_categories: :environment do
    show_spinner("Adding categories to the database") { add_categories }
  end

  desc "Add the authors to the database"
  task add_authors: :environment do
    show_spinner("Adding authors to the database") { add_authors }
  end

  desc "Add the users to the database"
  task add_users: :environment do
    show_spinner("Adding users to the database") { add_users }
  end

  desc "Add the comments to the database"
  task add_comments: :environment do
    show_spinner("Adding comments to the database") { add_comments }
  end

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :classic)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  def add_articles
    50.times do |i|
      title = Faker::Lorem.sentence.delete(".")
      body = Faker::Lorem.paragraph(sentence_count: rand(150..200))
      category = Category.all.sample
      author = Author.all.sample
      article = Article.create!(title: title, body: body, category: category, author: author)

      article.cover_image.attach(io: File.open(Rails.root.join("lib", "tasks", "images", "article", "0#{(i % 3) + 1}.jpg")), filename: "article_#{(i % 3) + 1}.jpg")
      article.save!
    end
  end

  def add_categories
    ["Rails", "React", "Node.js", "Python", "Java", "C#", "PHP", "SQL", "NoSQL", "DevOps"].each_with_index do |name, index|
      Category.create!(name: name, description: Faker::Lorem.paragraph(sentence_count: rand(5..10)), cover_image: File.open(Rails.root.join("lib", "tasks", "images", "category", "category#{(index % 8) + 1}.jpg")))
    end
  end

  def add_authors
    10.times do |i|
      author = Author.create!(
        name: Faker::Name.name,
        description: Faker::Lorem.paragraph(sentence_count: rand(5..10)),
        facebook_profile_url: Faker::Internet.url(host: "facebook.com"),
        instagram_profile_url: Faker::Internet.url(host: "instagram.com"),
        twitter_profile_url: Faker::Internet.url(host: "twitter.com"),
        linkedin_profile_url: Faker::Internet.url(host: "linkedin.com"),
        youtube_profile_url: Faker::Internet.url(host: "youtube.com"),
      )
      author.avatar_image.attach(io: File.open(Rails.root.join("lib", "tasks", "images", "avatar", "avatar-#{(i % 5) + 1}.png")), filename: "avatar_#{(i % 5) + 1}.png")
      author.save!
    end
  end

  def add_users
    30.times do
      User.create!(
        email: Faker::Internet.email,
        password: ENV["DEFAULT_PASSWORD"],
        password_confirmation: ENV["DEFAULT_PASSWORD"],
      )
    end
  end

  def add_comments
    100.times do
      Comment.create!(
        body: Faker::Lorem.paragraph(sentence_count: rand(5..10)),
        user: User.all.sample,
        article: Article.all.sample,
      )
    end
  end

  def reset_db
    # Termina todas as conexões ativas do banco de dados
    begin
      ActiveRecord::Base.connection.execute(
        "SELECT pg_terminate_backend(pg_stat_activity.pid)
         FROM pg_stat_activity
         WHERE pg_stat_activity.datname = current_database()
         AND pid <> pg_backend_pid();",
      )
    rescue => e
      puts "Aviso: Não foi possível terminar todas as conexões: #{e.message}"
    end

    ActiveRecord::Base.connection_pool.disconnect!
    Rake::Task["db:drop:_unsafe"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["dev:add_categories"].invoke
    Rake::Task["dev:add_authors"].invoke
    Rake::Task["dev:add_articles"].invoke
    Rake::Task["dev:add_users"].invoke
    Rake::Task["dev:add_comments"].invoke
  end
end
