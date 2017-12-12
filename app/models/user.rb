class User < ApplicationRecord
  # transform email address to downcase
  before_save { email.downcase! }

  # name, email 入力必須 最大長
  validates :name,
            presence: true,
            length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: {maximum: 128},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password,
            presence:true,
            length: {minimum: 6}


  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
