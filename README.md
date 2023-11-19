# GuardianSearcher

[![Gem Version](https://badge.fury.io/rb/guardian_searcher.svg)](https://badge.fury.io/rb/guardian_searcher)

This is a work in progress, and its status is currently an alpha version. Tests needs to be implemented and the code is not optimal.
The goal of this project is to provide a Ruby wrapper to query the Guardian Api and to experiment with some programming techniques.

Documentation of TheGuardian API is [Here](https://open-platform.theguardian.com/documentation/)

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

The results of the search can be used as they are, a Farady response object or you can parse - remember to check for the response code first - them using `GuardianSearcher::SearchResult` in the following way:

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

However if you want the gem to take care of the response codes and use its built in errors just use

```ruby
response = searcher.search('your keyword', { from_date: '2022-10-01', page_size: 10 })
results = GuardianSearcher::SearchResult.parse_with_codes(response)
```

This will return a `SearchResult` object or one of the following errors

```ruby
GuardianUnauthorizedError   # when a 401 is returned
GuardianBadRequestError     # when a 400 is returned
GuardianInternalServerError # when a 500 is returned
GuardianUnknownError        # when an error code is not among the above ones
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
At this point you can use the `SearchResult` object as it is or you could convert it to an Array of `Content` objects in the following way:
```ruby
generator = GuardianSearcher::Helpers::Generator.new
# results is the SearchResult object created before which has an attribute
# called results. Not a great name choice but sorry about that
contents = generator.generate(results.results, "GuardianSearcher::Content")
```

Each element of the `contents` Array will be an instance of the `Content` class, with a number of attributes that depends on the returned results i.e. that
if an element of the results attribute is something like:
```ruby
{"id"=>"football/2022/jun/27/football-transfer-rumours-chelsea-to-sign-matthijs-de-ligt-from-juventus",
    "type"=>"article",
    "sectionId"=>"football",
    "sectionName"=>"Football",
    "webPublicationDate"=>"2022-06-27T08:42:20Z",
    "webTitle"=>"Football transfer rumours: Chelsea to sign Matthijs de Ligt from Juventus? ",
    "webUrl"=>"https://www.theguardian.com/football/2022/jun/27/football-transfer-rumours-chelsea-to-sign-matthijs-de-ligt-from-juventus",
    "apiUrl"=>"https://content.guardianapis.com/football/2022/jun/27/football-transfer-rumours-chelsea-to-sign-matthijs-de-ligt-from-juventus",
    "isHosted"=>false,
    "pillarId"=>"pillar/sport",
    "pillarName"=>"Sport"}
```
One element of the `contents` array will be something like:

```ruby
<GuardianSearcher::Content:0x0000000150b7fe70
  @api_url="https://content.guardianapis.com/football/2022/jun/27/football-transfer-rumours-chelsea-to-sign-matthijs-de-ligt-from-juventus",
  @id="football/2022/jun/27/football-transfer-rumours-chelsea-to-sign-matthijs-de-ligt-from-juventus",
  @is_hosted=false,
  @pillar_id="pillar/sport",
  @pillar_name="Sport",
  @section_id="football",
  @section_name="Football",
  @type="article",
  @web_publication_date="2022-06-27T08:42:20Z",
  @web_title="Football transfer rumours: Chelsea to sign Matthijs de Ligt from Juventus? ",
  @web_url="https://www.theguardian.com/football/2022/jun/27/football-transfer-rumours-chelsea-to-sign-matthijs-de-ligt-from-juventus">
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
