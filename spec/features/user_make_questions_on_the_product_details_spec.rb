require 'rails_helper'

feature 'User makes public questions on products' do
  scenario 'sucessfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)
    Question.create!(title: 'Padrão', content: 'Padrão do teclado é nacional (ABNT) ou internacional?', 
                     product: product, user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click
    click_on 'Fazer uma pergunta'
    fill_in 'Título', with: 'Padrão'
    fill_in 'Pergunta', with: 'Padrão do teclado é nacional (ABNT) ou internacional?'
    click_on 'Postar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Teclado membrana Bright')
    expect(page).to have_content('Padrão')
    expect(page).to have_content('Padrão do teclado é nacional (ABNT) ou internacional?')
    expect(page).to have_content()
  end

  xscenario 'and the owner of the product answers it' do
    
  end

  xscenario 'and anyone in the company can see' do
    
  end
end