# Add a declarative step here for populating the DB with movies.

Given(/the following movies exist/) do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(
      title: movie["title"],
      rating: movie["rating"],
      release_date: movie["release_date"])


  end
end

Then(/(.*) seed movies should exist/) do |n_seeds|
  expect(Movie.count).to eq n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then(/^I should see "(.*)" before "(.*)" in the movie list$/) do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  first_position = page.body.index(e1)
  sec_position = page.body.index(e2)

  expect(first_position).not_to be_nil
  expect(sec_position).not_to be_nil
  expect(first_position).to be < sec_position
end


# Make it easier to express checking or unchecking several boxes at once
#  "When I check only the following ratings: PG, G, R"

When(/I check the following ratings: (.*)/) do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |rating|
    check(rating.strip)
  end  
end

Then(/^I should (not )?see the following movies: (.*)$/) do |no, movie_list|
  # Take a look at web_steps.rb Then /^(?:|I )should see "([^"]*)"$/
  movie_list.split(",").each do |title|
   if no
    step %{I should not see "#{title.strip}"}
   else
    step %{I should see "#{title.strip}"}
   end
  end  
end

Then(/^I should see all the movies$/) do
  # Make sure that all the movies in the app are visible in the table
  puts "URL: #{page.current_url}"
  
  puts "DATABASE COUNT: #{Movie.count}"
  puts "PAGE ROW COUNT: #{page.all('table tbody tr').length}"
  Movie.all.each do |movie|
    expect(page).to have_content(movie.title)
  end  

end

