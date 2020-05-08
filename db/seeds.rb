
User.destroy_all 
Recipe.destroy_all
Ingredient.destroy_all
Post.destroy_all
RecipeIngredient.destroy_all
Reaction.destroy_all
Cuisine.destroy_all


50.times do 
    response = RestClient.get('https://randomuser.me/api/')
    data = JSON.parse(response)
    User.create(name:data["results"][0]["name"]["first"] , age: data["results"][0]["dob"]["age"], email: data["results"][0]["email"], location: data["results"][0]["location"]["city"], picture: data["results"][0]["picture"]["large"], password: data["results"][0]["login"]["password"] )
end 

50.times do
    response = RestClient.get("https://api.spoonacular.com/recipes/random?apiKey=#{ENV['API_KEY']}")
    data = JSON.parse(response)

    cuisine = Cuisine.create_or_find_by(name: data["recipes"][0]["dishTypes"][0]) 

    recipe = Recipe.create(name: data["recipes"][0]["title"], instructions: data["recipes"][0]["instructions"], cuisine_id: cuisine.id, picture: data["recipes"][0]["image"], prep_time: data["recipes"][0]["readyInMinutes"], serving_size:data["recipes"][0]["servings"])

    count = 0
    while count < data["recipes"][0]["extendedIngredients"].size do
        ingredient = Ingredient.create_or_find_by(name: data["recipes"][0]["extendedIngredients"][count]["name"], picture: data["recipes"][0]["extendedIngredients"][count]["image"])
        RecipeIngredient.create(recipe_id: recipe.id, ingredient_id: ingredient.id) 
        count += 1
    end
end 

150.times do 
    Post.create(description: Faker::Quote.famous_last_words, rating: rand(1..5), user_id: User.all.sample.id, recipe_id: Recipe.all.sample.id, like: rand(1..20), dislike: rand(1..20), disgust: rand(1..20), love: rand(1..20))
end 

250.times do 
    Reaction.create(comment: Faker::Quote.yoda, post_id: Post.all.sample.id, user_id: User.all.sample.id) 
end 
