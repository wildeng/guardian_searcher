# GuardianSearcher

This is a work in progress, and its status is currently not even an alpha version. Tests needs to be implemented and the code is not optimal.
The goal of this project is to provide a Ruby wrapper to query the Guardian Api and to experiment with some programming techniques.

If you wanna try it you need to have an API key and use it as an environment variable.

```bash
  export guardian_api_key = "<your_api_key"
```
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'guardian_searcher'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install guardian_searcher

## Usage

```ruby
  # To include the gem in your code
  require 'guardian_searcher'

  # To initialise the gem
  searcher = GuardianSearcher::Search.new(api_key: <your-api-key>)

  # Simplest usage
  results = searcher.search('your keyword') 
```

There are some supported option that will be mapped to the api query and these are in the Options
class

```ruby
{
  from_date: "from-date",
  to_date: "to-date",
  page_size: "page-size",
  page: "page"
}
```

In this way your search could become something like

```ruby
results = searcher.search('your keyword', { from_date: '2022-10-01', page_size: 10 })
```

If you add something unsupported it will throw an `OptionsNotSupportedError`

The results of the search can be used as they are, a Farady response object or you can parse them using `GuardianSearcher::SearchResult` in the following way:

```ruby
response_body = searcher.search('your keyword', { from_date: '2022-10-01', page_size: 10 }).body
results = GuardianSearcher::SearchResult.parse_results(body: response_body)
```
This will return a `SearchResult` object which the following attributes:

```ruby
@current_page
@results # an array with all the search results
@page_size # paging size
@pages # number of pages
@start # starting page
```

Of interest the structure of a single element of the results array, which is an Hash array similar to this

```ruby
{"id"=>"football/2022/sep/23/player-mutiny-exposes-deeper-issues-within-spanish-womens-football",
    "type"=>"article",
    "sectionId"=>"football",
    "sectionName"=>"Football",
    "webPublicationDate"=>"2022-09-23T19:20:09Z",
    "webTitle"=>"Player mutiny exposes deeper issues within Spanish women’s football | Sid Lowe",
    "webUrl"=>"https://www.theguardian.com/football/2022/sep/23/player-mutiny-exposes-deeper-issues-within-spanish-womens-football",
    "apiUrl"=>"https://content.guardianapis.com/football/2022/sep/23/player-mutiny-exposes-deeper-issues-within-spanish-womens-football",
    "isHosted"=>false,
    "pillarId"=>"pillar/sport",
    "pillarName"=>"Sport"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/guardian_searcher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/guardian_searcher/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GuardianSearcher project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/guardian_searcher/blob/master/CODE_OF_CONDUCT.md).
