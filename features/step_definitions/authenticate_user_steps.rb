# I can send and accept JSON requests
Given(/^I send and accept JSON$/) do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
end


# Sign up
Given(/^I am a valid user$/) do
  @user = User.find_by(:email => 'vitaliy@yatsunyk.com')

  expect(@user.nil?).to eq(false)
end

When(/^I perform sign\-up with required parameters$/) do
  user = FactoryGirl.build(:user)

  post users_path, "{\"user\": #{user.to_json}}"
end

Then(/^the response should be successful$/) do
  expect(last_response.status).to eq(200)
end

And(/^I should receive a valid user identifier$/) do
  page = JSON.parse(last_response.body)
  expect(page.has_key?('id')).to eq(true)
  expect(page['id'].class.to_s).to eq('Fixnum')
end


# Sign-in
When(/^I perform sign\-in with user credentials$/) do
  session = FactoryGirl.build(:user, email: 'vitaliy@yatsunyk.com', password: 'vyatsunyk')

  post sessions_path, "{\"session\": #{session.to_json}}"
end

And(/^I should receive a valid access token$/) do
  page = JSON.parse(last_response.body)
  expect(page.has_key?('access_token')).to eq(true)
  expect(page['access_token'].length).to be > 0
end


# Sign-out
And(/^I am logged in$/) do
  @user = User.find_by(:email => 'vitaliy@yatsunyk.com')
  @user.signin
  header 'Access-Token', @user.access_token

  expect(@user.signedin?).to eq(true)
end

When(/^I perform sign\-out$/) do
  #header 'Access-Token', @user.access_token

  delete sessions_path
end

And(/^I should receive a positive response$/) do
  expect(last_response.status).to eq(200)

  page = JSON.parse(last_response.body)
  expect(page.has_key?('message')).to eq(true)
  expect(page['message']).to eq('success')
end


# Failed sign-up
When(/^I perform sign\-up with missing parameters$/) do
  body = { user: { email: nil, password: 'somepassword', name: 'Some Name' } }

  post users_path, body.to_json
end

When(/^I perform sign\-up with incorrect parameters$/) do
  body = { user: { email: 'incorrectemailstring', password: 'somepassword', name: 'Some Name' } }

  post users_path, body.to_json
end

Then(/^the response should be unprocessable entity/) do
  expect(last_response.status).to eq(422)
end

Then(/^the response should be unauthorized/) do
  expect(last_response.status).to eq(401)
end

And(/^I should receive error description$/) do
  page = JSON.parse(last_response.body)
  expect(page.has_key?('message')).to eq(true)
  expect(page['message'].length).to be > 0
end


# Failed sign-in
When(/^I perform sign\-in with missing parameters$/) do
  body = { session: { email: nil, password: 'somepassword' } }

  post sessions_path, body.to_json
end

When(/^I perform sign\-in with incorrect parameters$/) do
  body = { session: { email: 'nonexistent@email.address', password: 'somepassword' } }

  post sessions_path, body.to_json
end