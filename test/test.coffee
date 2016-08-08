path = require 'path'

require('chai').should()

BookshelfFixtureLoader = require '..'

knex = require('knex')
  client: 'sqlite3'
  connection:
    filename: ':memory:'
  useNullAsDefault: yes

bookshelf = require('bookshelf') knex
bookshelf.plugin 'registry'

before () ->
  bookshelf.model 'Test',
    tableName: 'test'

  knex.schema.createTableIfNotExists 'test', (table) ->
    table.increments()
    table.string 'name'
    return

describe 'BookshelfFixtureLoader', () ->
  it 'should load json file', () ->
    BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'test.json'

    Model = bookshelf.model('Test')
    Model.forge(id: 1).fetch().then (row) ->
      row.get('name').should.equal 'test 1'
      return

  it 'should load yaml file', () ->
    BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'test.yaml'

    Model = bookshelf.model('Test')
    Model.forge(id: 2).fetch().then (row) ->
      row.get('name').should.equal 'test 2'
      return

  return