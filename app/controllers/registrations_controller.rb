class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    return redirect_to(root_path) if logged_in?

    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.role = :general
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "登録が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(
      :nickname, :email, :password, :password_confirmation,
      :last_name, :first_name, :last_name_kana, :first_name_kana, :birthday
    )
  end
end
