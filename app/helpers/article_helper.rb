# frozen_string_literal: true

module ArticleHelper
  def markdown(text)
    sanitize(Markdown.new(text).to_html)
  end
end
