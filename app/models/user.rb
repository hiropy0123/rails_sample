class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest

  # name, email 入力必須 最大長
  validates :name,
            presence: true,
            length: {maximum: 50, allow_blank: true}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: {maximum: 128, allow_blank: true},
            format: {with: VALID_EMAIL_REGEX, allow_blank: true},
            uniqueness: {case_sensitive: false, allow_blank: true}

  has_secure_password
  validates :password,
            presence:true,
            length: {minimum: 6, allow_blank: true},
            allow_nil: true


  # クラスメソッドを使って、selfにdigestとnew_tokenメソッドを定義
  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # ランダムなトークンを返す
    # SecureRandomはRubyの乱数生成機能
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end


  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
