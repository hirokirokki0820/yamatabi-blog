class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :require_admin_user, only: %i[ new create edit update destroy ]

  def index
    @categories = Category.all
  end

  def show
    @posts = @category.posts.published.page(params[:page]).per(12).order(created_at: :desc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.permalink = @category.name if @category.permalink.blank?
    if @category.save
      redirect_to categories_path, notice: 'Category was successfully created'
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: 'Category was successfully updated'
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Category was successfully destroyed'
  end

  private

  def category_params
    params.require(:category).permit(:name, :permalink)
  end

  def set_category
    @category = Category.find_by(permalink: params[:permalink])
  end

end
