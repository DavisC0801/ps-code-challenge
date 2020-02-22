![](https://assets-global.website-files.com/5b69e8315733f2850ec22669/5b749a4663ff82be270ff1f5_GSC%20Lockup%20(Orange%20%3A%20Black).svg)

### Welcome to the take home portion of your interview! We're excited to jam through some technical stuff with you, but first it'll help to get a sense of how you work through data and coding problems. Work through what you can independently, but do feel free to reach out if you have blocking questions or problems.

1) This requires Postgres (9.4+) & Rails(4.2+), so if you don't already have both installed, please install them.

2) Download the data file from: https://github.com/gospotcheck/ps-code-challenge/blob/master/Street%20Cafes%202015-16.csv

3) Add a varchar column to the table called `category`.

4) Create a view with the following columns[provide the view SQL]
    - post_code: The Post Code
    - total_places: The number of places in that Post Code
    - total_chairs: The total number of chairs in that Post Code
    - chairs_pct: Out of all the chairs at all the Post Codes, what percentage does this Post Code represent (should sum to 100% in the whole view)
    - place_with_max_chairs: The name of the place with the most chairs in that Post Code
    - max_chairs: The number of chairs at the place_with_max_chairs

    This view can be accessed through the path /resturants. The view is passed two instance variable by the controller, with the value set to a model class methods to perform a query and aggregation to retrieve the post code, total places and total chairs and chairs pct columns for the first query, and max chairs and place with max chairs as a second query. This is due to the scoping required for a groupwise maximum needing two queries, and as the data will be equal length, there is a small efficiency benefit from iterating through both arrays in the view instead of merging them in the controller.

    This project includes unit and feature testing to confirm the model methods are returning the correct data from the database, as well as feature testing to confirm display of the correct data on the view.

5) Write a Rails script to categorize the cafes and write the result to the category according to the rules:[provide the script]
    - If the Post Code is of the LS1 prefix type:
        - `# of chairs less than 10: category = 'ls1 small'`
        - `# of chairs greater than or equal to 10, less than 100: category = 'ls1 medium'`
        - `# of chairs greater than or equal to 100: category = 'ls1 large' `
    - If the Post Code is of the LS2 prefix type:
        - `# of chairs below the 50th percentile for ls2: category = 'ls2 small'`
        - `# of chairs above the 50th percentile for ls2: category = 'ls2 large'`
    - For Post Code is something else:
        - `category = 'other'`

    The created rake task is meant to load the database and assign a category at the same time. The rake task will reset the database to create a clean start and re-load the database using the CSV file. A model method to assign a category is written and can be invoked to write the category to the database without using the rake task. to execute, run rake import:resturaunts.

    Testing of the rake task was completed manually, a model test is written to confirm the behavior of the script is working as intended, including edge cases such as LS1 prefix with 10 and 100 chairs.

6) Write a custom view to aggregate the categories [provide view SQL AND the results of this view]
    - category: The category column
    - total_places: The number of places in that category
    - total_chairs: The total chairs in that category

    This view can be accessed through the path /categories. The view is passed a single instance variable by the controller, with the value set to a model class method to perform a query and aggregation to retrieve the category, total places and total chairs columns.

    This project includes unit and feature testing to confirm the model methods are returning the correct data from the database, as well as feature testing to confirm display of the correct data on the view.

7) Write a script in rails to:
    - For street_cafes categorized as small, write a script that exports their data to a csv and deletes the records
    - For street cafes categorized as medium or large, write a script that concatenates the category name to the beginning of the name and writes it back to the name column

    This rake task will write a csv file with the name Small Cafes 2015-16 to the root directory. this task can be invoked through running rake utility:export_small. The script to rename medium or large cafes can be ran through rake utility:rename_large.

    Model tests were written to read and evaluate the created CSV and to confirm records are not in the database, as well as that the large restaurants were renamed. Rake tasks were tested manually.

8) Show your work and check your email for submission instructions.

9) Celebrate, you did great!
