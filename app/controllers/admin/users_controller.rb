class Admin::UsersController < ApplicationController
  before_action :if_not_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # NOTE: adminだけが使える全てのアクションを作成
  def index
    @users = User.all.includes(:tasks).order(created_at: :desc)
      # n+1問題解消策
  end

  def new
    @user = User.new
  end

  def  create
    @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: 'ユーザを登録しました'
      else
        render :new
      end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザを更新しました'
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: 'ユーザを削除しました' }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def if_not_admin
    if current_user.present?
      unless current_user.admin?
        redirect_to tasks_path, notice: '管理者以外アクセスできません'
      end
    end
  end

  def set_user
    @user = User.find(params[:id])
  end
end
