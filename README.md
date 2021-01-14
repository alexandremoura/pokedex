# Pokedex App

This app was developed using MVC design pattern to solve a challenge proposed to me.

1. The first screen, the app shows a list of pokemons (50 each time) presenting its name and an image. Scrolls the table to bottom to load more 50. A searchbar is used to filter the list.

2. When tap on item, a custom animation is used to transition between screens. Its anime the pokemon image from list to main image on detail screen.

3. Detail screen displays the following information about a pokemon: Name, height, weight, base experience, abilities, types, forms and stats. Swipe (right or left) to navigate between pokemons. The star button can be use to favorite it. The list of favorite pokemon is saved on user preferences and the pokemon data is sended to Webhook, as proposed (check at https://webhook.site/#!/3ac48a85-6637-469d-81cc-2a85b9de2458/725a1716-6248-4873-bf8b-93096b95ddf1/1).

4. Tha Unit Test is used to check the first call on fetch pokemons return 50 items and a UITest check if, after tap on first table cell, next screen displays an imageView and a table cell with label content equals "bulbasaur"

5. How to use: After download the code, type `pod intall` in terminal at the projet directory. Then open the Pokemon.xcworkspace.

6. The Pokeapi wrapper could be used to make it faster, but, what would be fun?

