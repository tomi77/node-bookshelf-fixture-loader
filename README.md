# bookshelf-fixture-loader

Bookshelf fixtures loader

[![Build Status](https://travis-ci.org/tomi77/node-bookshelf-fixture-loader.svg?branch=master)](https://travis-ci.org/tomi77/node-bookshelf-fixture-loader)
[![Coverage Status](https://coveralls.io/repos/github/tomi77/node-bookshelf-fixture-loader/badge.svg?branch=master)](https://coveralls.io/github/tomi77/node-bookshelf-fixture-loader?branch=master)
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
    BookshelfFixtureLoader bookshelf, 'test.json', __dirname

    Model = bookshelf.model('Test')
    Model.forge(id: 1).fetch().then (row) ->
      row.get('name').should.equal 'test 1'
      return
~~~

or define full path:

~~~coffeescript
BookshelfFixtureLoader bookshelf, '/path/to/fixtures/test.yaml'
~~~

## TODO

* Tool to copy data from DB to fixture file
