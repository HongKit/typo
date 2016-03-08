Given /the following (.*?) exist:$/ do |type, table|
  table.hashes.map do |element|
    case type
    when "users"
      User.create(
        profile_id: element[:profile_id],
        login: element[:login],
        name: element[:name],
        password: element[:password],
        email: element[:email],
        state: element[:state]
      )
    when "articles"
      Article.create(
        title: element[:title],
        body: element[:body],
        user_id: User.find_by_login(element[:author]).id,
        state: element[:state],
      )
    when "comments"
      a = Article.find_by_title(element[:article_title])
      u = User.find_by_login(element[:author])
      Comment.create(
        user_id: u.id,
        article_id: a.id,
        body: element[:body],
        published: "published",
        state: element[:state],
        author: u.name
      )
    end
  end
end

Given /^I am logged in as "(.*?)" with password "(.*?)"$/ do |user, password|
  visit '/accounts/login'
  fill_in 'user_login', :with => user
  fill_in 'user_password', :with => password
  click_button 'Login'
  assert page.has_content? 'Login successful'
end

Given /^the article with ids "(.*?)" and "(.*?)" were merged$/ do |id1, id2|
  article = Article.find_by_id(id1)
  article.merge_with(id2)
end

Then /^"(.*?)" should be author of (\d+) articles$/ do |user, count|
  assert Article.find_all_by_author(User.find_by_name(user).login).size == Integer(count)
end