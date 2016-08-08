# bookshelf-fixture-loader

Bookshelf fixtures loader

[![Code Climate](https://codeclimate.com/github/tomi77/node-bookshelf-fixture-loader/badges/gpa.svg)](https://codeclimate.com/github/tomi77/node-bookshelf-fixture-loader)
[![dependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader)
[![devDependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/dev-status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader?type=dev)

## Installation

~~~bash
npm install bookshelf-fixture-loader --save-dev
~~~

## Usage

Fixture file format is inspired by Django fixture file format.

**fixtures/test.yaml**

~~~yaml
- id: 2
  model: 'Test'
  fields:
    name: 'test 2'
~~~

**fixtures/test.json**

~~~json
[
  {
    "id": 1,
    "model": "Test",
    "fields": {
      "name": "test 1"
    }
  }
]
~~~

In test file:

~~~coffeescript
path = require 'path'
BookshelfFixtureLoader = require 'bookshelf-fixture-loader'

knex = require('knex')
  client: 'sqlite3'
  connection:
    filename: ':memory:'
  useNullAsDefault: yes

bookshelf = require('bookshelf') knex
bookshelf.plugin 'registry'

describe 'BookshelfFixtureLoader', () ->
  it 'should load json file', () ->
    BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'test.json'

    Model = bookshelf.model('Test')
    Model.forge(id: 1).fetch().then (row) ->
      row.get('name').should.equal 'test 1'
      return
~~~
