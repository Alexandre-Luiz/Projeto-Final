require 'rails_helper'

feature 'User owner delete his ad' do
  scenario 'sucessfully' do
    user = User.create!(name: 'Fulano', password: '123456789', 
                        email: 'fulano@test.com', role: 'Estagiário',
                        department: 'Recursos humanos')
    Product.create!(name: 'Teclado', category: 'Eletrônicos', 
                              description: 'Teclado membrana Bright', price: '20', user: user)
    Product.create!(name: 'Mouse', category: 'Eletrônicos', 
                    description: 'Mouse logitech sem fio', price: '500', user: user)
    #question = Question.create!(content: 'As teclas possuem iluminação?', user: user, product: product)

    login_as(user, scope: :user)
    visit root_path
    click_on 'Ver produtos'
    find_link('Ver detalhes', href: product_path(Product.first)).click
    click_on 'Apagar anúncio'

    expect(current_path).to eq products_path
    expect(page).to have_content('Mouse')
    expect(page).to have_content('R$ 500,00')
    expect(page).not_to have_content('Teclado')
    expect(page).not_to have_content('R$ 20,00')
  end

  xscenario 'only the owner can delete' do
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
    click_on 'Ver detalhes'
    find_link('Apagar anúncio', :visible => :all).click


    expect(current_path).to eq product_path(Product.last)
    expect(page).to have_content('Sem autorização para apagar este anúncio.')
  end


end