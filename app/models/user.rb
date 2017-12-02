class User < ApplicationRecord

  # name, email 入力必須 最大長
  validates(:name, presence: true, length: {maximum: 50})

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates(:email, presence: true, length: {maximum: 128}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false})


end
