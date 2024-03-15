class UsersController < ApplicationController
before_action :ensure_correct_user, only: [:show]
before_action :set_user, only: [:show, :edit, :update, :destroy]
before_action :logout_required, only:[:new, :create]
skip_before_action :login_required, only: [:new, :create]

def new
  if logged_in?
    redirect_to user_path(current_user)
  else
    @user = User.new
  end
end

def  create
  @user = User.new(user_params)
  respond_to do |format|
    if @user.save
      log_in(@user)
      format.html { redirect_to tasks_path, notice: "アカウントを登録しました" }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end

def show
  if current_user == User.find(params[:id])
    @user = User.find(params[:id])
  else
    redirect_to(tasks_path, danger:"管理者以外アクセスできません")
  end
end

def edit
end

def update
  respond_to do |format|
    if @user.update(user_params)
      format.html { redirect_to user_path(@user), notice: "アカウントを更新しました" }
      format.json { render :show, status: :ok, location: @user }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end

def destroy
  @user.destroy
    respond_to do |format|
      format.html { redirect_to new_session_path, notice: t('flash.destroyed') }
      format.json { head :no_content }
    end
end


private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if @user.id != current_user.id
      flash[:notice] = "アクセス権限がありません"
      redirect_to tasks_path
    end
  end

end
