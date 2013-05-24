# DynamicController

[![Gem Version](https://badge.fury.io/rb/dynamic_controller.png)](https://rubygems.org/gems/dynamic_controller)
[![Build Status](https://travis-ci.org/gabynaiman/dynamic_controller.png?branch=master)](https://travis-ci.org/gabynaiman/dynamic_controller)
[![Coverage Status](https://coveralls.io/repos/gabynaiman/dynamic_controller/badge.png?branch=master)](https://coveralls.io/r/gabynaiman/dynamic_controller?branch=master)
[![Code Climate](https://codeclimate.com/github/gabynaiman/dynamic_controller.png)](https://codeclimate.com/github/gabynaiman/dynamic_controller)
[![Dependency Status](https://gemnasium.com/gabynaiman/dynamic_controller.png)](https://gemnasium.com/gabynaiman/dynamic_controller)

Simple way to add CRUD actions into Rails controllers.

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

## Explicit action specification

    class UsersController < ApplicationController
      has_crud_actions only: [:index, :new, :create]
    end

or

    class UsersController < ApplicationController
      has_crud_actions except: :destroy
    end


## Nested resources support

    class ProfilesController < ApplicationController
      has_crud_actions
      nested_of User
    end

If has more than one nested level should use

    class StreetsController < ApplicationController
      has_crud_actions
      nested_of Country
      nested_of City
    end

## Redefining responder

    class LanguagesController < ApplicationController
      has_crud_actions

      respond_to_create :html do
        redirect_to action: :index
      end

      respond_to_update do |format|
        format.html { redirect_to action: :index }
        format.json { render json: @language }
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
