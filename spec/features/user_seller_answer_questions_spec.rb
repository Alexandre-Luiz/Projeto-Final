require 'rails_helper'

feature 'User owner of the ad asnwers the questions made in its details' do
  scenario 'successfully' do
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
    click_on 'Responder'
    fill_in 'Resposta', with: 'Não possuem RGB. É um teclado básico.'
    click_on 'Enviar'

    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Pergunta: As teclas possuem iluminação?')
    expect(page).to have_content('Não possuem RGB. É um teclado básico.')
  end

  scenario 'but only the owner can view the link to answer' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: another_user)
    Question.create!(content: 'As teclas possuem iluminação?', user: another_user, product: product)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    click_on 'Ver detalhes'
    
    expect(page).to_not have_link('Responder')
  end

  scenario 'but theres no question' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: user)
    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.last)).click

    expect(page).to have_content('Ainda não há perguntas para esse produto.')
  end

  scenario 'but another user try to answer' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    another_user = User.create!(name: 'Beltrano', password: '123456789', 
                                email: 'beltrano@test.com', role: 'Diretor',
                                department: 'Recursos humanos')
    product = Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: another_user)
    question = Question.create!(content: 'As teclas possuem iluminação?', user: user, product: product)

    login_as(user, scope: :user)
    visit new_product_question_answer_path(product, question)
    click_on 'Enviar'

    expect(page).to have_content('Sem autorização para responder sobre esse produto')
  end
end