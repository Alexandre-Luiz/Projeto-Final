require 'rails_helper'

feature 'User makes public questions on products' do
  scenario 'sucessfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                    description: 'Teclado membrana Bright', price: '20', user: user)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click
    click_on 'Fazer uma pergunta'
    fill_in 'Qual a sua dúvida?', with: 'Padrão do teclado é nacional (ABNT) ou internacional?'
    click_on 'Postar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Teclado membrana Bright')
    expect(page).to have_content('Padrão do teclado é nacional (ABNT) ou internacional?')
  end

  scenario 'and anyone of the same company can see it' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                        email: 'beltrano@test.com', role: 'Diretor',
                        department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: user)
    Question.create!(content: 'As teclas possuem iluminação?', user: another_user, product: product)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click

    expect(page).to have_content('Usuário: Fulano')
    expect(page).to have_content('As teclas possuem iluminação?')
  end

  scenario 'but it can be blank' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: another_user)
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click
    click_on 'Fazer uma pergunta'
    click_on 'Postar'

    expect(page).to have_content('não pode ficar em branco')
  end

  scenario 'but user cant make questions on disabled products' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', 
                              user: another_user, status: :disabled)
    
    login_as(user, scope: :user)
    visit new_product_question_path(product)

    expect(current_path).to eq products_path
  end
end