# NutrientsRecipiesApp

<h3>Database ER Diagram</h3>
<img src="http://i.imgur.com/CLrLXFk.png">

<h3>Database (Initial) Schema:</h3>
Recipes (recipes_ID, source, recipes_name, category_ID)<br>
Ingredients (recieps_ID, ingredients_ID, Ingredients_name, amount, main)<br>
Macros (ingredients_ID, fats, carbs, calories, protein, sugar)<br>
Social (users_ID, users_ID)<br>
Nutrition_Log (user_ID, date, time, recipes_ID, quantity)<br>
Users(UserID, Email, Name, Height, Weight, Age, Program, LoginSource, APIToken)<br>
Friends(users_ID, users_ID)<br>

<h3>Current Ingredients Table Data</h3>
<img src="http://i.imgur.com/I14SNVn.png">

Demo:
<img src="http://g.recordit.co/GX7jtSOmN8.gif">

