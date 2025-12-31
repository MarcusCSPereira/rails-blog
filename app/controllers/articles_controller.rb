# frozen_string_literal: true

class ArticlesController < PublicController
  before_action :set_article, only: [:show]

  def show
    @other_articles = Article.includes(:author, :category, comments: :user)
      .with_attached_cover_image
      .where.not(id: @article.id)
      .order(updated_at: :desc)
      .limit(3)
    @comments = comments_sorted_by
  end

  private

  def set_article
    @article = Article.includes(:author, :category, comments: :user)
      .with_attached_cover_image
      .friendly.find(params.expect(:id))
  end

  def comments_sorted_by
    if params[:sort_by] == "last_comments"
      @article.comments.order(created_at: :asc)
    else
      @article.comments.order(created_at: :desc)
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :cover_image, :category_id)
  end
end
