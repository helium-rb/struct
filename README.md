# Helium::Struct

Basic but powerful and extensible data struct for ruby.

## Installatio

Add this line to your application's Gemfile:

```ruby
gem 'helium-struct'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install helium-struct

## Usage

To create your first Struct simply include `Helium::Struct` and define attributes:

```
class User
  include Helium::Struct

  attribute :name
  attribute :email
end

user = User.new
user.name = "Stan Klajn"
user.name #=> "Stan Klajn"
```

### Undefined values

Structs make a distinction between `undefined` and `nil` values.

```
u = User.new
#=>
# # User struct
# |  name: undefined
# | email: undefined
```

However, due to Ruby's limitation, `undefine` can only be internal implementation detail as it would be treated as true in all the conditionals. Struct will still return nil when you query an udnefined value:

```
u.name #=> nil
```

You can however test if given attribute is defined with:
```
u.defined?(:name) #=> false
u.name = nil
u.defined?(:name) #=> true
u.delete(:name)
u.defined?(:name) #=> false
```

### Hooks

Do not override your struct setters - use change hooks instead!

```
class Mentorship
  include Helium::Struct

  attribute :mentor_id
  attribute :mentor

  on_change(:mentor_id) { |value| self.mentor = value && Mentor.find(value) }
  on_change(:mentor) { |value| self.mentor_id = value&.id }
end

m = Mentorship.new
m.mentor_id = 1
m.mentor #=> Mentor(id: 1)

```

### Composability

You can compose one struct within another struct using `use` method. Composition maintains all the defined hooks which executes in the context of the original struct without copying any methods over. You can also provide optional `as:` keyword which will grant you access to the underlying struct.

```
class SimpleProfile
  include Helium::Struct

  attribute :username
  attribute :email

  on_change(:email) { |value| self.username = generate_username(value) }

  private

  def generate_username(value)
    ...
  end
end

class FullUser
  include Helium::Struct

  use User, as: :simple_user
  use SimpleProfile
end

fu = FullUser.new

fu.email = 'stan@klajn.com'
fu.username #=> <generated-username>

fu.simple_user
#=>
# # User struct
# | name: undefined
# | email: "stan@klajn.com"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/helium-struct. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/helium-struct/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Helium::Struct project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/helium-struct/blob/master/CODE_OF_CONDUCT.md).
