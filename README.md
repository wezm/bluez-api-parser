# bluez-api

Gem and tool for generating [D-Bus] introspection XML from the [BlueZ] API
documentation.

## Rationale

The BlueZ project does not appear to publish D-Bus introspection XML documents
for the API. The API is introspectable through D-Bus itself but the available
methods depend on the devices present on the host system.

The BlueZ API documentation is quite well structured though, which allows the
XML to be generated from it. The generated XML files may subsequently be used
to generate client bindings.

The generated XML is available in the [bluez-introspection-xml] repository.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bluez-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bluez-api

## Usage

There is a command line tool included in the gem that allows XML to be
generated from API files.

TODO: Finish this

## Development

Run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment with the gem pre-loaded.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/wezm/bluez-api-parser>.

## Credits

This gem is a port of the [bluezapi2qt tool][bluezapi2qt] that is a part of
[bluez-qt].

## License

This gem is licenced under the LGPL-2.1, the same as [bluez-qt], which it was
derived from it 

[D-Bus]: https://www.freedesktop.org/wiki/Software/dbus/
[BlueZ]: http://www.bluez.org/
[bluez-qt]: https://github.com/KDE/bluez-qt
[bluezapi2qt]: https://github.com/KDE/bluez-qt/tree/408bdaa752faa8afcf55499b164d89aa6af8aa0c/tools/bluezapi2qt
