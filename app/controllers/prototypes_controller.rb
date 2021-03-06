class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :show,]
  before_action :set_prototype, only: [:edit, :show]
  before_action :authenticate_user!, except: [:show, :index, :destroy]

  def index 
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end 
  
  def create
    @prototype = Prototype.new(prototype_params)
    # if文で保存状態によるページ遷移を条件分岐
    if @prototype.save
      redirect_to root_path
    else
      render :new 
    end
  end

  def show
    @comment = Comment.new
    # 投稿に紐づくすべてのコメントを代入
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    unless user_signed_in? && @prototype.user_id == current_user.id
      redirect_to action: :index
    end
  end
  
  def update
    prototype = Prototype.find(params[:id])
    # if文で更新状態を条件分岐
    if prototype.update(prototype_params)
      redirect_to "/prototypes/#{params[:id]}"
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to action: :index
  end
  

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  
  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
end
