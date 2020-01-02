class User < ApplicationRecord
  has_secure_password

  validates_presence_of :email
  validates_presence_of :password, if: :password_digest_changed?
  validate :check_password_format, if: :password_digest_changed?

  has_many :courses

  private def check_password_format
    {
      'must contain at least one digit' => /\d+/,
      #'must contain at least one lowercase letter' => /[a-z]+/,
      #'must contain at least one uppercase letter' => /[A-Z]+/,
      #'must contain at least one special character' => /[^A-Za-z0-9]+/,
    }.each do |rule, reg|
      errors.add(:password, rule) unless password && password.match(reg)
    end
  end
end
