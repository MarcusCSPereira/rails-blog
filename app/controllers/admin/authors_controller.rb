# frozen_string_literal: true

module Admin
  class AuthorsController < AdminController
    before_action :set_author, only: [:show, :edit, :update, :destroy, :destroy_avatar_image]
    def index
      @authors = Author.all
    end

    def show
    end

    def create
      @author = Author.new(author_params)
      @author.avatar_image.attach(author_params[:avatar_image])
      respond_to do |format|
        if @author.save
          format.html { redirect_to(admin_author_path(@author), notice: "Autor criado com sucesso.") }
          format.json { render(:show, status: :created, location: admin_author_path(@author)) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @author.errors, status: :unprocessable_entity) }
        end
      end
    end

    def new
      @author = Author.new
    end

    def edit
    end

    def update
      respond_to do |format|
        if @author.update(author_params)
          format.html { redirect_to(admin_author_path(@author), notice: "Autor atualizado com sucesso.") }
          format.json { render(:show, status: :ok, location: admin_author_path(@author)) }
        else
          format.html { render(:edit, status: :unprocessable_entity) }
          format.json { render(json: @author.errors, status: :unprocessable_entity) }
        end
      end
    end

    def destroy
      @author.destroy!
      respond_to do |format|
        format.html { redirect_to(admin_authors_path, notice: "Autor removido com sucesso.") }
        format.json { head(:no_content) }
      end
    end

    def destroy_avatar_image
      @author.avatar_image.purge
      respond_to do |format|
        format.turbo_stream { render(turbo_stream: turbo_stream.remove(@author)) }
      end
    end

    private

    def set_author
      @author = Author.find(params.expect(:id))
    end

    def author_params
      params.require(:author).permit(:name, :description, :avatar_image, :facebook_profile_url, :twitter_profile_url, :instagram_profile_url, :youtube_profile_url, :linkedin_profile_url)
    end
  end
end
