class PagesController < ApplicationController
  #ログインしている場合のみ接続許可
  before_action :authenticate_user!
  #サイドバープロフィール表示用のconcernsモジュール
  include ProfileDisplay
  before_action :profile_display


  def index
    @posts = Post.all.order(id: "DESC")

    #@posts = Post.page(params[:page]).per(50).all.order(id: "DESC") 


    @post = Post.new

    @post_comment = PostComment.new
    @post_comments = PostComment.all

    @likes_count = PostLike.all

  end

end
