# Administrate::Task::Ui

[![Ruby](https://github.com/joshmfrankel/administrate-task-ui/actions/workflows/ci.yml/badge.svg)](https://github.com/joshmfrankel/administrate-task-ui/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/administrate-task-ui.svg?icon=si%3Arubygems&icon_color=%23959da5)](https://badge.fury.io/rb/administrate-task-ui)

Run any Rake tasks directly inside Administrate

## Installation

This engine is dependent upon `administrate`. Please follow the excellent [Getting Started](https://administrate-demo.herokuapp.com/getting_started) before continuing to install `administrate-task-ui`.

Add this line to your application's Gemfile:

```ruby
gem "administrate-task-ui"
```

Then `bundle` or globally `gem install administrate-task-ui`.

Next run the install generator:

```ruby
rails generate administrate:task:ui:install
```

This will add a new route along with a initializer template.

## Configuration

`allowed_tasks` - An array of Rake tasks you would like to be runnable. This is a permissive check so the following will be matched.

```ruby
Administrate::Task::Ui.allowed_tasks = ["say:hello", "has_nested"]

#=> ["say:hello, "has_nested:task", "has_nested:task:another_one"]
```

`metadata` - A Proc that can be supplied to inject additional metadata into the TaskRun.

```ruby
Administrate::Task::Ui.metadata = -> do
  current_user = Current.user
  {
    user_id: current_user.id
  }
end
```

## Features

1. Run any Rake task from Administrate
2. View source code for a Rake task before running it
3. Lock any currently running Rake task from being re-run until completed
4. Filter dashboard by TaskRun status
5. Background jobs run Rake

## Contributing

- Pull requests welcome
- Be respectful

## License

The gem is available as open source under the terms of the modified [ANTIRACIST ETHICAL SOURCE LICENSE (ATR)](https://attheroot.dev).
