# Add URL
When(/^I add a URL$/) do
  url = FactoryGirl.build(:url)

  post urls_path, "{\"url\": #{url.to_json}}"
end


# Receive Tiny URL
And(/^I should receive a Tiny URL$/) do
  url = JSON.parse(last_response.body)
  expect(url.has_key?('tiny_path')).to eq(true)
  expect(url['tiny_path'].length).to eq(5)
end

Given(/^I have a valid Tiny URL$/) do
  @url = Url.find_by(:tiny_path => 'abcde')

  expect(@url.nil?).to eq(false)
  @tiny_url = @url.tiny_path
end

Given(/^I have an invalid Tiny URL$/) do
  @url = Url.find_by(:tiny_path => 'edcba')

  expect(@url.nil?).to eq(true)
  @tiny_url = 'edcba'
end


# Access Tiny URL
When(/^I open this Tiny URL$/) do
  visit "/#{@tiny_url}"
end

Then(/^I am redirected to underlying web path$/) do
  expect(page.current_url).to include(@url.path)
end


# Failed Tiny URL actions
When(/^I add an invalid URL$/) do
  url = FactoryGirl.build(:url, path: 'http:someinvalidwebpath.com')

  post urls_path, "{\"url\": #{url.to_json}}"
end

When(/^I add an empty empty URL$/) do
  url = FactoryGirl.build(:url, path: '')

  post urls_path, "{\"url\": #{url.to_json}}"
end

Then(/^I am presented with error message$/) do
  expect(page).to have_content 'ERROR:'
end