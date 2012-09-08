# DynamicController

Simple way to add CRUD actions to Rails controllers.

Suppoted formats HTML and JSON.

Tested with Ruby 1.9.3 and Rails 3.2.8.

## Installation

Add this line to your application's Gemfile:

    gem 'dynamic_controller'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamic_controller

## Adding CRUD actions to resource controller

    class UsersController < ApplicationController
      has_crud_actions
    end

has_crud_actions adds index, show, new, edit, create, update and destroy actions to controller

## Nested resources support

    class ProfilesController < ApplicationController
      has_crud_actions nested_of: User
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
