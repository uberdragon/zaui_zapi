# Developer Guide

This document provides an overview of the structure of the project and how to work with the code when extending the gem.

## Getting Started

The gem provides a wrapper around the [Zaui](https://www.zaui.com) zAPI.  The entry point for most interactions is the `Zaui` class inside the `lib` directory.  You can build the gem locally with:

```bash
gem build zaui_zapi.gemspec
```

and install it via:

```bash
gem install ./zaui_zapi-$(grep VERSION lib/version.rb | cut -d\' -f2).gem
```

When the gem is loaded you will normally configure the zAPI endpoint using the environment variable `ZAPI_URI` or pass a custom URL to `Zapi.new`.

```ruby
client = Zapi.new(zapi_url: "https://zapi.example.com")
```

Authentication helpers are provided by `ZapiAgent` and `ZapiEmployee`.  They perform the login call and store the session details.  A simplified example:

```ruby
agent = ZapiAgent.new(username: 'agent@example.com', password: 'secret')
if agent.is_logged_in?
  puts agent.session_hash # => {user_id: ..., account_id: ..., api_token: ...}
end
```

Once authenticated you can pass the session details to the `Zaui` high level interface:

```ruby
zaui = Zaui.new(session: agent.session_hash)
categories = zaui.get_activity_categories
```

## Library Structure

- **lib/zapi.rb** – Low level HTTP helper used to POST XML payloads to the API.
- **lib/zapi_response.rb** – Parses API XML responses to Ruby hashes using `Hash.from_xml`.
- **lib/zapi_xml.rb** – Generates XML requests for the available API methods.
- **lib/zapi_agent.rb** and **lib/zapi_employee.rb** – Helper classes for logging in and storing session information.
- **lib/zaui.rb** – Provides convenience wrappers around zAPI calls (adding items to cart, processing payments, etc.).
- **lib/zapi_object.rb** – Small utility class used to build objects from hashes at runtime.
- **lib/version.rb** – Current gem version used in the gemspec.

These files are loaded by `lib/zaui_zapi.rb` which requires each component.

## Dependencies

Runtime dependencies declared in `zaui_zapi.gemspec` are:

- `rails`
- `activesupport`

Development dependencies include `minitest` for potential testing.  Currently the repository does not ship with a test suite.  Contributions should include unit tests written with `minitest`.

## Contributing

1. Fork the repository and create a branch for your change.
2. Add your code and corresponding tests if applicable.
3. Ensure the gem builds without warnings:

   ```bash
   gem build zaui_zapi.gemspec
   ```
4. Submit a pull request describing your changes.

The gem is licensed under the GNU General Public License, version 2.  See `LICENSE` for details.

