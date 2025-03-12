# Implementation Notes

This page documents choices made in throughout the process of building a CSV-reading, digested data-displaying application.
Rails will form the backbone of the application and will be responsible for ingestion and digestion of the data.
React will display the data to the user.
This is my response to the challenge [here](https://github.com/BlueOnionLabs/interview-fullstack).

## My Focus

There's so much that an open ended challenge could cover!
Broadly speaking, I'll highlight:

- build data integrity / safety into the app from the beginning
- find and highlight easy abstractions that make for clean code
- be accurate (show automated tests for the solution)
- show a few favorite tools and design patterns

I'll be avoiding details such as:

- user authentication and account management
- build automation or continuous integration tooling

## Getting Started - Rails New

I'll be using some gems like [MaintenanceTasks](https://github.com/Shopify/maintenance_tasks).
The `--api` option when generating the Rails app leaves out a bunch of stuff that I'll need to for MaintenanceTasks.
We skip tests here so that I can add Rspec and we'll add Tailwind in case we decide to go that route.

```sh
rails new journal --skip-test --css=tailwind
cd journal
bundle add --group=development,test rspec-rails guard guard-rspec guard-rubocop rubocop rubocop-rails
bundle add maintenance_tasks interactor
```

