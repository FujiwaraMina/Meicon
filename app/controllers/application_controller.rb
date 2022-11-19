class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # ログイン
  def after_sign_in_path_for(resource)
    flash[:notice] = "ログインしました"
    root_path
  end
  # ログアウト
  def after_sign_out_path_for(resource)
    flash[:notice] = "ログアウトしました"
    root_path
  end

  protected
  # 新規登録にname追加
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys:[:name])
  end
end
