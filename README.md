# QnA

This project is a question and answer service. Users can ask questions on topics
while also answering questions from other users. 

The project also has other functions that help make this process easier for
users, such as adding comments, attaching files and links, voting, selecting the
best answer, giving out awards, subscribing to questions, and using full text
search to find questions and answers.

## Project structure

The project structure goes as follows:

At the base of the project are the Questions and their associated Answers. Both
questions and answers have an author (User). They can also both have comments,
links, and votes. Votes and comments belong to User, while the links can only be
attached to a model by its author and as such, don't have a user association.
Questions have an award that can be given out to the author of the best answer
by the question author. Questions can also have many subscribers (Users) through
subscriptions. The Authorization model stores information about user oauth
authentication methods.

## Development

This application uses encrypted credentials and as such, requires extra setup to
run.
To use this application, you need to do the following:
Clone the repository.
Install the 2.6.5 ruby version,
Install the ruby mysql packages.
Install Sphinx.
Install all the necessary gems using Bundler.
Install yarn and packages.
Create a postgres role with a `createdb` role, create a `config/database.yml`
file with a postgresql adapter.
To get OAuth working, add OAuth application ids and secrets to credentials for
github and vk.

Credentials example:

```
development:
  github:
    app_id: ...
    app_secret: ...
  vk:
    app_id: ...
    app_secret: ...

test:
  github:
    app_id: ...
    app_secret: ...
  vk:
    app_id: ...
    app_secret: ...

profuction:
  github:
    app_id: ...
    app_secret: ...
  vk:
    app_id: ...
    app_secret: ...
```

## Additional information

- This was a learning project for the online school Thinknetica. In the
development of this project I've used various methods and techniques.

- The entirety of the project was developed with accordance to the TDD/BDD
methods.

- Most of the UI actions have Ajax integrated and are streamed using ActionCable.

- Uploaded files are stored in an AWS cloud.

- Application allows authentication with user credentials (implemented with the
devise gem), or using OAuth (implemented with the omniauth gem).

- All of the actions need to be authorized (implemented with the cancancan gem).

- The application has API, which implements authentication with doorkeeper and
allows CRUD actions on questions and answers.

- The weekly digest function and subscription notification functions are
implemented using ActiveJobs with sidekiq.

- Full text search is implemented using thinkingsphinx. The database is indexed
every 30 minutes (implemented with the whenever gem).

- The application also implements page caching.
