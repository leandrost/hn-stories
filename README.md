## HN Stories
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)

Stories from Hacker News

## Requirements

- Ruby 2.7

## Getting started

1. Clone this repo:
```
git clone git@github.com:leandrost/hn-stories.git
cd hn-stories
```

2. Setup the application:
```
bundle config --local path vendor # optional - config bundler to locally install gems on ./vendor
bin/setup
```

3. Run the application:
```
bin/rails server
```

## Tests

```
bin/rspec
```

## Deploy

```
git push heroku master
```
