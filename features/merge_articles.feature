Feature: Merge Articles
  As a blog administrator
  So that I can group similar topics
  I want to be able to merge articles with same topic

  Background: Initial Database seed
    Given the blog is set up
    Given the following users exist:
      | profile_id | login     | name      | password | email         | state  |
      | 2          | non_admin | non_admin | 12345678 | non@admin.com | active |
    Given the following articles exist:
      | title    | author    | body     | state     |
      | Article1 | non_admin | Content1 | published |
      | Article2 | non_admin | Content2 | published |
    Given the following comments exist:
      | author    | body     | article_title | state |
      | non_admin | Comment1 | Article1      | ham   |
      | non_admin | Comment2 | Article2      | ham   |
  
  Scenario: A non-admin cannot merge articles
	  Given I am logged in as "non_admin" with password "12345678"
	  And I am on the articles index page
	  When I follow "Article1"
	  Then I should not see "Merge Articles"

  Scenario: An admin can merge articles
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    Then I should see "Merge Articles"
    
  Scenario: No id exist leads to an error message
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    When I fill in "merge_with" with "3"
    And I press "Merge"
    Then I should be on the admin content page
    And I should see "Error, invalid ID to merge"
  
  Scenario: Success message on successful merge
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should be on the admin content page
    And I should see "Article1"
    And I should not see "Article2"
    And I should see "Articles merge successful"
  
  Scenario: If articles are merged, the merged article should contain the text of both previous articles
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should be on the admin content page
    When I follow "Article1"
    And I should see "Content1"
    And I should see "Content2"
  
  Scenario: If articles are merged, the merged article should have one author (either one of the authors of the original article)
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should be on the admin content page
    And I should see "non_admin"
    
  Scenario: Comments on each of the two original articles need to all carry over and point to the new, merged article
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should be on the admin content page
    When I am on the home page
    And I follow "Article1"
    Then I should see "Comment1"
    And I should see "Comment2"
    
  Scenario: The title of the new article should be the title from either one of the merged articles
    Given I am logged into the admin panel
    And I am on the articles index page
	  When I follow "Article1"
    When I fill in "merge_with" with "4"
    And I press "Merge"
    Then I should be on the admin content page
    And I should see "Article1"
    And I should not see "Article2"