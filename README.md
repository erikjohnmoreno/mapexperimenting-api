# AppAPI

__Rails 5.2__ API template using:
- __PostgreSQL__ database
- __RSpec__ tests
- __Puma__ server
- __[JWT](https://github.com/jwt/ruby-jwt)__ authentication
- __[Fast JSON API](https://github.com/Netflix/fast_jsonapi)__ serializer
- __[Ransack](https://github.com/activerecord-hackery/ransack#search-matchers)__ for collection filtering
- __[Sparkpost](https://github.com/the-refinery/sparkpost_rails)__ for emails
- __[Capistrano](https://github.com/capistrano/rails)__ for deployment

## Getting started
1. Create required config files `database.yml`, `application.yml`
2. `bundle install`
3. `rails db:create db:migrate`

## Usage

_Checkout [demo branch](https://github.com/open-sourcepad/app-api/tree/demo) to see sample usage._

#### Controller
```ruby
# app/controllers/posts_controller.rb
# This controller implements all CRUD operations with filters and pagination

class PostsController < ApplicationController
  private
  def obj_params
    params.require(:post).permit(*%i(title content))
  end
end
```
For `belongs_to` restrictions like current_user:
```ruby
# app/controllers/posts_controller.rb

class PostsController < ApplicationController
  private
  def obj_params
    params.require(:post).permit(*%i(title content))
  end

  def collection
    current_user.posts.all
  end
end
```

#### Serializer
```ruby
# app/serializers/post_serializer.rb

class PostSerializer
  include SerializerConcern

  attributes *%i(title content)

  attribute :created_at do |obj|
    format_time(obj.created_at)
  end

  attribute :updated_at do |obj|
    format_time(obj.updated_at)
  end
end
```

## Built-in endpoints and sample CRUD
   METHOD  | URL    |    DESCRIPTION
---------- | ------------------------- | --------------
   POST    | /signup           | Register as a new user
   POST    | /signin           | Get auth token
   POST    | /forgot_password  | Generate reset password code
   GET     | /verify_code      | Verify reset password code
   PUT     | /new_password     | Updates forgotten password
   GET     | /jwt_test         | Sample JWT implementation (see [specs/requests/jwt_test_spec.rb](https://github.com/open-sourcepad/app-api/blob/demo/spec/requests/jwt_test_spec.rb))
   GET     | /posts            | List posts
   GET     | /posts?page=2&per_page=20 | with pagination (per_page default is 20)
   GET     | /posts?q[title_eq]=Source | with filter (see more in [specs/requests/posts/index_spec.rb](https://github.com/open-sourcepad/app-api/blob/demo/spec/requests/posts/index_spec.rb))
   POST    | /posts            | Create post
   GET     | /posts/:id        | Read post
   PATCH   | /posts/:id        | Update post
   DELETE  | /posts/:id        | Delete post

## Feel free to contribute
We appreciate code reviews, feedbacks, and pull requests. Let's learn together. Happy coding!
