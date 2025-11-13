# frozen_string_literal: true

require "tty-spinner"

namespace :dev do
  desc "Add the articles to the database"
  task add_articles: :environment do
    show_spinner("Adding articles to the database") { add_articles }
  end

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}", format: :classic)
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  def add_articles
    50.times do
      title = Faker::Lorem.sentence.delete(".")
      body = Faker::Lorem.paragraph(sentence_count: rand(150..200))
      Article.create!(title: title, body: body)
    end
  end
end
