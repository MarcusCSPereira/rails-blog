# frozen_string_literal: true

class CommentsController < PublicController
  before_action :authenticate_user!, only: [:create]
  def create
    @article = Article.friendly.find(params.expect(:article_id))
    comment = @article.comments.new(comment_params)
    if comment.save
      redirect_to(article_path(@article), notice: "Comentário criado com sucesso")
    else
      redirect_to(article_path(@article), alert: "Erro em comentário: #{comment.errors.full_messages.join(", ")}")
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
