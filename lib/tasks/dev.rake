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
      article = Article.create!(title: title, body: body, category: category)
      article.cover_image.attach(io: File.open(Rails.root.join("lib", "tasks", "images", "article_#{(i % 3) + 1}.jpg")), filename: "article_#{(i % 3) + 1}.jpg")
      article.save!
    end
  end

  def add_categories
    ["Rails", "React", "Node.js", "Python", "Java", "C#", "PHP", "SQL", "NoSQL", "DevOps"].each do |name|
      Category.create!(name: name)
    end
  end

  def reset_db
    ActiveRecord::Base.connection_pool.disconnect!
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    Rake::Task["dev:add_categories"].invoke
    Rake::Task["dev:add_articles"].invoke
  end
end
