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
Create a postgres role with a 'createdb' role, create a config/database.yml file
with a postgresql adapter.
Add OAuth application id and secret to credentials for github and vk.

## Additional information


