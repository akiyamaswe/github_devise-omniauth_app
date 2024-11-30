class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  # providerとuidが両方存在する場合のみ一意性を検証
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? && uid.present? }

  # パスワード検証をスキップするための属性を追加
  attr_writer :skip_password_validation

  def self.from_omniauth(auth)
    user = User.find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    user = User.find_by(email: auth.info.email)
    if user
      user.update!(provider: auth.provider, uid: auth.uid)
      return user
    end

    User.create!(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email || "#{auth.uid}@example.com",
      password: Devise.friendly_token[0, 20]
    )
  end

  protected

  def password_required?
    return false if @skip_password_validation
    super
  end
end