class Users::RegistrationsController < Devise::RegistrationsController
  # パスワード入力なしでの更新を許可
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # パスワードパラメータがある場合とない場合で処理を分ける
    if password_params_present?
      if resource.update(account_update_params)
        bypass_sign_in resource, scope: resource_name
        set_flash_message! :notice, :updated
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      # パスワード以外の更新
      if resource.update_without_password(account_update_params_without_password)
        set_flash_message! :notice, :updated
        bypass_sign_in resource, scope: resource_name
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    end
  end

  private

  def password_params_present?
    params[:user][:password].present? || params[:user][:password_confirmation].present?
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def account_update_params_without_password
    params.require(:user).permit(:email)
  end

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end
end