class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.order(:id)
  end

  def show
  end

  def new
    @user = User.new(role: :general)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "ユーザーを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = user_params
    attrs = attrs.except(:password) if attrs[:password].blank?
    if @user.update(attrs)
      redirect_to @user, notice: "ユーザーを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "ユーザーを削除しました", status: :see_other
    else
      redirect_to @user, alert: @user.errors.full_messages.to_sentence.presence || "削除できませんでした", status: :see_other
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted = params.require(:user).permit(
      :nickname, :email, :password, :password_confirmation,
      :last_name, :first_name, :last_name_kana, :first_name_kana, :birthday, :role
    )
    permitted.delete(:password_confirmation) if permitted[:password_confirmation].blank?
    permitted
  end
end
