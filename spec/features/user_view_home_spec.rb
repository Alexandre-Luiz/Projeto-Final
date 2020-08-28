require 'rails_helper'

feature 'User view home page'do

  scenario 'but first, must to be logged in' do

    visit root_path

    expect(current_path).to eq(new_user_session_path)

  end

  scenario 'successfully view the homepage' do
    User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    visit root_path
    fill_in 'Email', with: 'fulano@test.com'
    fill_in 'Senha', with: '123456789'
    click_on 'Entrar'
    

    expect(page).to have_content('Bem vindo ao marketplace')
    expect(page).to have_content('Login efetuado com sucesso.')
    expect(page).to have_link('Sair', href: destroy_user_session_path)
  end

  scenario 'user should complete profile to register product' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    login_as(user, scope: :user)
    visit root_path
    
    expect(page).to have_content('Complete seu perfil para poder negociar.')
    expect(page).not_to have_link('Cadastrar produto')
  end

  scenario 'user can logout' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Sair'

    expect(current_path).to eq(new_user_session_path)
    
  end

end