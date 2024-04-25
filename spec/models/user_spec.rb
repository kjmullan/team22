# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  Pronouns               :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  password               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_id                    (id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

describe 'Login' do
  let!(:user) { FactoryBot.create(:user) }
  specify 'I can log in as a user' do
    
    visit '/users/sign_in'

    fill_in 'Email', with: 'user.email.address@sheffield.ac.uk'
    fill_in 'Password', with: 'Password123'

    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end
  specify 'I cannot login with incorrect details' do

    visit '/users/sign_in'

    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'Password'

    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
  specify 'I cannot leave any fields blank' do

    visit '/users/sign_in'

    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end

describe 'Registration' do
  specify 'I can register for an account' do

    visit '/users/sign_up'

    fill_in 'Email', with: 'newuser@sheffield.ac.uk'
    fill_in 'Password', with: 'Password123'
    fill_in 'Password confirmation', with: 'Password123'

    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  specify 'I cannot leave the email field blank' do

    visit '/users/sign_up'

    fill_in 'Password', with: 'Password123'
    fill_in 'Password confirmation', with: 'Password123'

    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
  specify 'I cannot leave the password field blank' do

    visit '/users/sign_up'

    fill_in 'Email', with: 'email@email.com'

    click_on 'Sign up'

    expect(page).to have_content "Password can't be blank"
  end
  specify 'I cannot register for an account if the password does not match the password confirmation' do

    visit '/users/sign_up'

    fill_in 'Email', with: 'email@email.com'
    fill_in 'Password', with: 'Password123'
    fill_in 'Password confirmation', with: 'Password'

    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end

describe 'Forgotten Password' do
  specify 'I cannot leave the email field blank' do

    visit '/users/password/new'

    click_on 'Send me reset password instructions'

    expect(page).to have_content "Email can't be blank"
  end
end
