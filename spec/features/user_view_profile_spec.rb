require 'rails_helper'

feature 'User view his profile' do
  scenario 'and edits/completes his personal information' do
    user = User.create!(name: 'Fulano', password: '123456789', email: 'fulano@test.com')
    
    login_as(user, scope: :user)
    visit root_path
    click_on 'Editar perfil'
    fill_in 'Nome', with: 'Fulano'
    fill_in  'Cargo', with: 'Gerente'
    fill_in 'Departamento', with: 'Marketing'
    click_on 'Atualizar'

    #expect(current_path).to eq root_path
    expect(user.name).to eq 'Fulano'
    expect(user.role).to eq 'Gerente'
    expect(user.department).to eq 'Marketing'

  end
end

