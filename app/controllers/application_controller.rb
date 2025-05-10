class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # 未ログイン時に各ページにアクセスできなくする
  before_action :authenticate_user!

  private

  # サインイン後に/users/:idにリダイレクト
  def after_sign_in_path_for(_resource_or_scope)
    user_path(current_user)
  end

  # サインアウト後に/users/sign_inにリダイレクト
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  # アカウント編集後に/users/:idにリダイレクト
  def signed_in_root_path(_resource_or_scope)
    user_path(current_user)
  end
end
