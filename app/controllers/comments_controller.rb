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

  def like
    @comment = Comment.find(params[:id])
    comment_like_dislike = CommentLikeDislike.find_or_initialize_by(comment_id: @comment.id, user_id: current_user.id)

    # Se já existe um dislike, remove-o primeiro
    if comment_like_dislike.persisted? && comment_like_dislike.action_type == "dislike"
      @comment.decrement(:dislike)
      comment_like_dislike.destroy
      comment_like_dislike = CommentLikeDislike.new(comment_id: @comment.id, user_id: current_user.id)
    end

    # Se já existe um like, remove-o; caso contrário, adiciona
    if comment_like_dislike.persisted? && comment_like_dislike.action_type == "like"
      comment_like_dislike.destroy
      @comment.decrement(:like)
      notice = "Like removido com sucesso"
    else
      comment_like_dislike.action_type = "like"
      comment_like_dislike.save
      @comment.increment(:like)
      notice = "Like adicionado com sucesso"
    end
    @comment.save
    redirect_to(article_path(@comment.article), notice:)
  end

  def dislike
    @comment = Comment.find(params[:id])
    comment_like_dislike = CommentLikeDislike.find_or_initialize_by(comment_id: @comment.id, user_id: current_user.id)

    # Se já existe um like, remove-o primeiro
    if comment_like_dislike.persisted? && comment_like_dislike.action_type == "like"
      @comment.decrement(:like)
      comment_like_dislike.destroy
      comment_like_dislike = CommentLikeDislike.new(comment_id: @comment.id, user_id: current_user.id)
    end

    # Se já existe um dislike, remove-o; caso contrário, adiciona
    if comment_like_dislike.persisted? && comment_like_dislike.action_type == "dislike"
      comment_like_dislike.destroy
      @comment.decrement(:dislike)
      notice = "Deslike removido com sucesso"
    else
      comment_like_dislike.action_type = "dislike"
      comment_like_dislike.save
      @comment.increment(:dislike)
      notice = "Deslike adicionado com sucesso"
    end
    @comment.save
    redirect_to(article_path(@comment.article), notice:)
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end
