class User < ApplicationRecord
  has_many :products
  has_many :questions
  has_many :answers

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def user_full_profile?
    name.present? && role.present? && department.present?
  end

  private

end
