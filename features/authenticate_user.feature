# Feature summary: User auth by encrypted password with bcrypt
# Access token with securerandom - updated on each login

Feature: Authenticate User
  In order to access the system
  As a visitor
  I want to be able to sign-up and sign-in

  Background:
    Given I send and accept JSON

  Scenario: Successful sign-up
    When I perform sign-up with required parameters
    Then the response should be successful
    And I should receive a valid user identifier

  Scenario: Successful sign-in
    Given I am a valid user
    When I perform sign-in with user credentials
    Then the response should be successful
    And I should receive a valid access token

  Scenario: Successful sign-out
    Given I am a valid user
    And I am logged in
    When I perform sign-out
    Then the response should be successful
    And I should receive a positive response

  Scenario: Failed sign-up missing data
    When I perform sign-up with missing parameters
    Then the response should be unprocessable entity
    And I should receive error description

  Scenario: Failed sign-in missing data
    When I perform sign-in with missing parameters
    Then the response should be unauthorized
    And I should receive error description

  Scenario: Failed sign-up incorrect data
    When I perform sign-up with incorrect parameters
    Then the response should be unprocessable entity
    And I should receive error description

  Scenario: Failed sign-in incorrect data
    When I perform sign-in with incorrect parameters
    Then the response should be unauthorized
    And I should receive error description

# TODO: Add UI testing using capybara