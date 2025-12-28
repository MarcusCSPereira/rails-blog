# frozen_string_literal: true

module Admin
  class CategoriesController < AdminController
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = Category.all
    end

    def show
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      respond_to do |format|
        if @category.save
          format.html { redirect_to(admin_category_path(@category), notice: "Categoria criada com sucesso.") }
          format.json { render(:show, status: :created, location: admin_category_path(@category)) }
        else
          format.html { render(:new, status: :unprocessable_entity) }
          format.json { render(json: @category.errors, status: :unprocessable_entity) }
        end
      end
    end

    def edit
    end

    def update
      respond_to do |format|
        if @category.update(category_params)
          format.html { redirect_to(admin_category_path(@category), notice: "Categoria atualizada com sucesso.") }
          format.json { render(:show, status: :ok, location: admin_category_path(@category)) }
        else
          format.html { render(:edit, status: :unprocessable_entity) }
          format.json { render(json: @category.errors, status: :unprocessable_entity) }
        end
      end
    end

    def destroy
      @category.destroy!
      respond_to do |format|
        format.html { redirect_to(admin_categories_path, notice: "Categoria removida com sucesso.") }
        format.json { head(:no_content) }
      end
    end

    private

    def set_category
      @category = Category.find(params.expect(:id))
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
