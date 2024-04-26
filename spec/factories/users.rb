# == Schema Information
#
# Table name: users
#
#  id                       :uuid             not null, primary key
#  bypass_invite_validation :boolean
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  email                    :string
#  encrypted_password       :string           default(""), not null
#  invite_code              :string
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  name                     :string
#  password                 :string
#  pronouns                 :string
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  role                     :integer
#  sign_in_count            :integer          default(0), not null
#  status                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_users_on_id                    (id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user, class: User do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}.email.address@sheffield.ac.uk" }
    password { 'Password123' }
    password_confirmation { 'Password123' }
    Pronouns { "She/Her" }
    status { 1 }
    role { :admin }

    trait :young_person do
      role { :young_person }
    end

    trait :supporter do
      role { :supporter }
    end

    trait :loved_one do
      role { :loved_one }
      sequence(:name) { |n| "loved_one#{n}" }
      sequence(:email) { |n| "loved_one#{n}@sheffield.ac.uk" }
    end
    
    trait :admin do
      name { "admin1" }
      email { 'admin.email.address@sheffield.ac.uk' }
      password { 'Password123' }
      password_confirmation { 'Password123' }
      Pronouns { "She/Her" }
      status { 1 }
      role { :admin }
    end
  end
end
