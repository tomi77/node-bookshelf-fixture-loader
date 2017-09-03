# bookshelf-fixture-loader

Bookshelf fixtures loader

[![Build Status](https://travis-ci.org/tomi77/node-bookshelf-fixture-loader.svg?branch=master)](https://travis-ci.org/tomi77/node-bookshelf-fixture-loader)
[![Coverage Status](https://coveralls.io/repos/github/tomi77/node-bookshelf-fixture-loader/badge.svg?branch=master)](https://coveralls.io/github/tomi77/node-bookshelf-fixture-loader?branch=master)
[![Code Climate](https://codeclimate.com/github/tomi77/node-bookshelf-fixture-loader/badges/gpa.svg)](https://codeclimate.com/github/tomi77/node-bookshelf-fixture-loader)
[![dependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader)
[![devDependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/dev-status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader?type=dev)
![Downloads](https://img.shields.io/npm/dt/bookshelf-fixture-loader.svg)

## Installation

~~~bash
npm install bookshelf@"^0.10.0" knex@"^0.13.0" --save
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

~~~js
var knex = require('knex')({
  client: 'sqlite3',
  connection: {
    filename: ':memory:'
  },
  useNullAsDefault: true
});

var bookshelf = require('bookshelf')(knex);
bookshelf.plugin('registry');

var BookshelfFixtureLoader = require('bookshelf-fixture-loader')(bookshelf, __dirname);

describe('BookshelfFixtureLoader', function() {
  it('should load json file', function() {
    BookshelfFixtureLoader('test.json');

    var Model = bookshelf.model('Test');
    Model.forge({id: 1}).fetch().then(function(row) {
      row.get('name').should.equal('test 1');
    });
  });
});
~~~

or define absolute path:

~~~js
BookshelfFixtureLoader('/path/to/fixtures/test.yaml');
~~~
