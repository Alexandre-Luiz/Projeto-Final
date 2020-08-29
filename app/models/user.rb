class User < ApplicationRecord
  has_many :product

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def profile_complete?
    current_user.role.blank? || current_user.department.blank? || current_user.name.blank?
  end
end
