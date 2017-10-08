# bookshelf-fixture-loader

Bookshelf fixtures loader

[![Build Status](https://travis-ci.org/tomi77/node-bookshelf-fixture-loader.svg?branch=master)](https://travis-ci.org/tomi77/node-bookshelf-fixture-loader)
[![Coverage Status](https://coveralls.io/repos/github/tomi77/node-bookshelf-fixture-loader/badge.svg?branch=master)](https://coveralls.io/github/tomi77/node-bookshelf-fixture-loader?branch=master)
[![Code Climate](https://codeclimate.com/github/tomi77/node-bookshelf-fixture-loader/badges/gpa.svg)](https://codeclimate.com/github/tomi77/node-bookshelf-fixture-loader)
[![dependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader)
[![devDependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/dev-status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader?type=dev)
[![peerDependencies Status](https://david-dm.org/tomi77/node-bookshelf-fixture-loader/peer-status.svg)](https://david-dm.org/tomi77/node-bookshelf-fixture-loader?type=peer)
![Downloads](https://img.shields.io/npm/dt/bookshelf-fixture-loader.svg)

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

var FixtureLoader = require('bookshelf-fixture-loader')(bookshelf, __dirname);
var fixtures = new FixtureLoader();
var Model = bookshelf.model('Test');

describe('FixtureLoader', function() {
  it('should load json file', function() {
    fixtures.load('test.json')
    .insert()
    .then(function() {
      return Model.forge({id: 1}).fetch();
    })
    .then(function(row) {
      row.get('name').should.equal('test 1');
    });
  });
});
~~~

or define absolute path:

~~~js
new FixtureLoader('/path/to/fixtures/test.yaml');
~~~
