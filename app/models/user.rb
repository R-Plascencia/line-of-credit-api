class User < ApplicationRecord
    has_many :credit_lines, :dependent => :destroy

    validates_presence_of :first_name, :email, :password_digest
    validates :email, uniqueness: true

    has_secure_password
end
