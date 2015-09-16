# Feature summary: add and access Tiny Url

Feature: Tiny Url functionality
  In order to access Tiny URLs
  As a user
  I want to be able to add URLs

  Background:
    Given I send and accept JSON

  Scenario: Successfully add URL
    Given I am a valid user
    And I am logged in
    When I add a URL
    Then the response should be successful
    And I should receive a Tiny URL

  Scenario: Successfully access Tiny URL
    Given I have a valid Tiny URL
    When I open this Tiny URL
    Then I am redirected to underlying web path

  Scenario: Failed add URL with invalid data
    Given I am a valid user
    And I am logged in
    When I add an invalid URL
    Then the response should be unprocessable entity
    And I should receive error description

  Scenario: Failed add URL with missing data
    Given I am a valid user
    And I am logged in
    When I add an empty empty URL
    Then the response should be unprocessable entity
    And I should receive error description

  Scenario: Failed access Tiny URL
    Given I have an invalid Tiny URL
    When I open this Tiny URL
    Then I am presented with error message

# TODO: Add UI testing using capybara