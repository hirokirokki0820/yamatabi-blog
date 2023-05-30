class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_images, only: %i[ new edit ]
  before_action :require_admin_user, only: %i[ new create edit update destroy ]
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
    @post = Post.new()
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    if @post.save
      if @post.draft?
        redirect_to post_url(@post), notice: "記事が保存されました。"
      else
        redirect_to post_url(@post), notice: "記事が公開されました。"
      end
    else
      @post = Post.new(post_params)
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if @post.draft?
      @post.destroy
      redirect_to draft_posts_url, notice: "Post was successfully destroyed."
    else
      @post.destroy
      redirect_to posts_url, notice: "Post was successfully destroyed."
    end
  end

  # パーマリンクがすでに存在するものかどうかチェックする
  def is_registered?
    post = Post.find_by(permalink: params[:permalink]) # クリエパラメータに埋め込んだパーマリンク（フォームに入力したキーワード）から投稿を検索（なければnullを返す）
    render json: post
  end

  # 特定のツイートを取得する
  def get_tweet
    tweet_url = "https://api.twitter.com/2/tweets/#{params[:tweet_id]}"
    options = {
      method: 'GET',
      headers: {
        # "User-Agent" => "v2RubyExampleCode",
        "Authorization" => "Bearer #{Rails.application.credentials[:twitter][:bearer_token]}",
      }
    }
    request = Typhoeus::Request.new(tweet_url, options)
    response = request.run
    render json: response.body
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find_by(permalink: params[:permalink])
      if @post.nil?
        render_404 # ページが見つからなかった場合は404を返す
      end
    end

    def set_images
      if current_user.images.exists?
        @images = current_user.images.page(params[:page]).per(30).order(created_at: :desc)
      end
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :thumbnail, :permalink, :status, category_ids: []).merge(user_id: current_user.id)
    end

    # アップロード済みの画像からサムネイル画像を検索
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

    # Twitter API Key & Access Token
    def twitter_client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.credentials[:twitter][:api_key]
        config.consumer_secret     = Rails.application.credentials[:twitter][:api_secret]
        config.access_token        = Rails.application.credentials[:twitter][:access_token]
        config.access_token_secret = Rails.application.credentials[:twitter][:access_token_secret]
      end
    end
end
