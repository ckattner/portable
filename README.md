# Portable

[![Gem Version](https://badge.fury.io/rb/portable.svg)](https://badge.fury.io/rb/portable) [![Build Status](https://travis-ci.org/bluemarblepayroll/portable.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/portable) [![Maintainability](https://api.codeclimate.com/v1/badges/4b47ce94b0c9d889e648/maintainability)](https://codeclimate.com/github/bluemarblepayroll/portable/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/4b47ce94b0c9d889e648/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/portable/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Portable is a virtual document object modeling library.  Out of the box is provides a CSV writer but others for other formats like Microsoft Excel could easily be implemented and used.

This library utilizes [the Realize library](https://github.com/bluemarblepayroll/realize) that allows you to express transformation pipelines.  Essentially this library is meant to be the transformation and load steps within a larger ETL system. We currently use this in production paired up with [Dbee](https://github.com/bluemarblepayroll/dbee) for data sources to go from configurable data model + query to file.

## Installation

To install through Rubygems:

````
gem install install portable
````

You can also add this to your Gemfile:

````
bundle add portable
````

## Examples

### Getting Started Writing CSV Files

Consider the following data provider/source:

````ruby
patients = [
  { first: 'Marky', last: 'Mark', dob: '2000-04-05' },
  { first: 'Frank', last: 'Rizzo', dob: '1930-09-22' }
]

data_provider = Portable::Data::Provider.new(
  data_sources: {
    data_rows: patients,
    keys: %i[first last dob]
  }
)
````

**Note:** Data::Provider and Data::Source objects are pretty basic, on purpose, so they can be easily re-implemented based on an application's specific needs.

We could configure the most basic document like so:

````ruby
document = nil # or {} or Portable::Document.new
````

The above document says I would like a document with one sheet, and since I did not provide a data_table specification, I would like all the fields emitted from the data source.

Combining a document + writer + data provider yields a set of documents.  It may emit more than one file if the writer does not know how to write intra-file sheets (i.e. CSV files).

````ruby
writer    = Portable::Writers::Csv.new(document)
name      = File.join('tmp', 'patients.csv')
written   = writer.write!(filename: name, data_provider: data_provider)
````

We should now have a CSV file at tmp/patients.csv that looks like this:

first | last | dob
----- | ---- | -----
Marky | Mark | 2000-04-05
Frank | Rizzo | 1930-09-22

### Realize Transformation Pipelines

This library uses Realize under the hood, so you have the option of configuring any transformation pipeline for each column.  Reviewing [Realize's list of transformers](https://github.com/bluemarblepayroll/realize#transformer-gallery) is recommended to see what is available.

Let's expand our CSV example above with different headers and date formatting:

````ruby
patients = [
  { first: 'Marky', last: 'Mark', dob: '2000-04-05' },
  { first: 'Frank', last: 'Rizzo', dob: '1930-09-22' }
]

data_provider = Portable::Data::Provider.new(
  data_sources: {
    data_rows: patients,
    keys: %i[first last dob]
  }
)

document = {
  sheets: [
    {
      data_table: {
        columns: [
          {
            header: 'First Name',
            transformers: [
              { type: 'r/value/resolve', key: :first }
            ]
          },
          {
            header: 'Last Name',
            transformers: [
              { type: 'r/value/resolve', key: :last }
            ]
          },
          {
            header: 'Date of Birth',
            transformers: [
              { type: 'r/value/resolve', key: :dob },
              { type: 'r/format/date', output_format: '%m/%d/%Y' },
            ]
          }
        ]
      }
    }
  ]
}

writer    = Portable::Writers::Csv.new(document)
name      = File.join('tmp', 'patients.csv')
written   = writer.write!(filename: name, data_provider: data_provider)
````

Executing it the same way would now yield a different CSV file:

````
First Name | Last Name | Date of Birth
---------- | --------- | -------------
Marky      | Mark      | 04/05/2000
Frank      | Rizzo     | 09/22/1930
````

Realize is also [pluggable](https://github.com/bluemarblepayroll/realize#plugging-in-transformers), so you are able to create your own and plug them directly into Realize.

### Options

Each writer can choose how and which options to support.

#### CSV Options

The following options are available for customizing CSV documents:

* byte_order_mark: (optional, default is nothing): This option will write out a [byte order mark](https://en.wikipedia.org/wiki/Byte_order_mark) identifying the endianess for the file.  This is useful for ensuring applications like Microsoft Excel open CSV files properly.  See Portable::Modeling::ByteOrderMark constants for acceptable values.

### Static Header/Footer Rows

The main document model can also include statically defined rows to place either at the header (above data table) or footer (below data table) locations.  You can also have the data_source inject static header and footer rows as well.  For example:

````ruby
patients = [
  { first: 'Marky', last: 'Mark', dob: '2000-04-05' },
  { first: 'Frank', last: 'Rizzo', dob: '1930-09-22' }
]

data_provider = Portable::Data::Provider.new(
  data_sources: {
    data_rows: patients,
    keys: %i[first last dob],
    header_rows: [
      %w[FIRST_START LAST_START DOB_START]
    ],
    footer_rows: [
      %w[FIRST_END LAST_END DOB_END]
    ]
  }
)

document = {
  sheets: [
    {
      header_rows: [
        [ 'Run Date', '04/05/2000' ],
        [ 'Run By', 'Hops the Bunny' ],
        [],
        [ 'BEGIN' ]
      ],
      footer_rows: [
        [ 'END' ]
      ]
    }
  ]
}

writer    = Portable::Writers::Csv.new(document)
name      = File.join('tmp', 'patients.csv')
written   = writer.write!(filename: name, data_provider: data_provider)
````

Using this document configuration would yield a CSV with four "header rows" at the top, one "data table header row", two data rows, and one "footer row".  This is not easily illustrated in Markdown, but this would be the result:

````
Run Date   | 04/05/2000
Run By     | Hops the Bunny

BEGIN
FIRST_START | LAST_START | DOB_START
first       | last       | dob
----------- | ---------- | -------------
Marky       | Mark       | 2000-04-05
Frank       | Rizzo      | 1930-09-22
FIRST_END   | LAST_END   | DOB_END
END
````

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check portable.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/portable.git)
4. Navigate to the root folder (cd portable)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````bash
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````bash
bundle exec guard
````

Also, do not forget to run Rubocop:

````bash
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/portable/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Code of Conduct

Everyone interacting in this codebase, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bluemarblepayroll/portable/blob/master/CODE_OF_CONDUCT.md).

## License

This project is MIT Licensed.
