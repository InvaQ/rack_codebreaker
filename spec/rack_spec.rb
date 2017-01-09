content = File.read(File.expand_path('../../config.ru', __FILE__))
Capybara.app = eval "Rack::Builder.new {( #{content}\n )}"

feature Racker do

  scenario 'Open login page' do
    visit '/'
    expect(page).to have_content('Wellcome to C o d e B r e a k e r')
  end

  scenario 'Show players name' do
    visit '/'
    fill_in('player', with: 'Bob')
    click_button('Login')
    expect(page).to have_content('Hello Bob')
  end

  scenario 'show default players name' do 
    visit '/'
    click_button('Login')
    expect(page).to have_content('Hello John Doe')
  end

  scenario 'show players last guess' do 
    visit '/game'
    fill_in('guess', with: '1234')
    click_button('Check')
    expect(page).to have_content('Your last guess was 1234')
  end
  
  scenario 'show players tries left' do 
    visit '/game'
    fill_in('guess', with: '1234')
    click_button('Check')
    expect(page).to have_content('Tries left 5')
  end

  scenario 'play again' do 
    visit '/game'
    fill_in('guess', with: '1234')
    click_button('play again')
    expect(page).to have_content('Tries left 6')
  end
  scenario 'get hint' do 
    visit '/game'
    click_button('get hint')
    visit '/hint'
    expect(page).to have_content('One number of the secret code is')
  end

  scenario 'warning about hitns' do 
    visit '/game'
    2.times do
      click_button('get hint')
      visit '/hint'
    end
    expect(page).to have_content("You don't have any hints!")
  end


end