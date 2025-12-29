# frozen_string_literal: true

require "tty-spinner"

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
  end
end
