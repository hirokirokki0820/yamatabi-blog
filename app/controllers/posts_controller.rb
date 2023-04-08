class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  # before_action :require_admin_user, only: %i[ new create edit update destroy ]
  before_action :require_same_user_edit, only: %i[ confirm edit update destroy ]
  before_action :authenticate_user!, except: %i[ index show ]

  # GET /posts or /posts.json
  def index
    @posts = Post.published.page(params[:page]).per(12)
  end

  # 下書き投稿リスト
  def draft
    @posts = current_user.posts.draft.page(params[:page]).per(12)
  end

  # GET /posts/1 or /posts/1.json
  def show
    require_login if @post.draft?
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        if @post.draft?
          redirect_to edit_post_path(@post), notice: "下書き保存に成功しました。"
        else
          format.html { redirect_to post_url(@post), notice: "記事が公開されました。" }
          format.json { render :show, status: :created, location: @post }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :thumbnail, :status, category_ids: []).merge(user_id: current_user.id)
    end

    def uploaded_image
      current_user.images.find(params[:post][:thumbnail]) if params[:post][:thumbnail]
    end

      # 同一ユーザーのみ許可
    def require_same_user_edit
      if current_user != @post.user && user_signed_in? && !current_user.admin?
        flash[:alert] = "投稿の編集、削除は投稿者ご自身のみ可能です。"
        redirect_to @post
      end
    end
end
