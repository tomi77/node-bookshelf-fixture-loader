path = require 'path'

require('chai').should()
assert = require('chai').assert

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

beforeEach () ->
  knex('test').del()

describe 'BookshelfFixtureLoader', () ->
  describe 'should load fixtures from', () ->
    it 'JSON file', () ->
      BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'test.json'

      Model = bookshelf.model('Test')
      Model.forge(id: 1).fetch().then (row) ->
        row.get('name').should.equal 'test 1'
        return

    it 'YAML file', () ->
      BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'test.yaml'

      Model = bookshelf.model('Test')
      Model.forge(id: 2).fetch().then (row) ->
        row.get('name').should.equal 'test 2'
        return

    it 'many files', () ->
      BookshelfFixtureLoader bookshelf, [
        path.resolve __dirname, 'fixtures', 'test.json'
        path.resolve __dirname, 'fixtures', 'test.yaml'
      ]

      Model = bookshelf.model('Test')
      Model.count().then (cnt) ->
        cnt.should.equal 2
        return

  describe 'should throw Error', () ->
    it 'when cannot find module', () ->
      bfl = () ->
        BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'no_module.yaml'
        return
      assert.throws bfl, Error, 'Undefined model: NonExistent'

    it 'when use unsupported format', () ->
      bfl = () ->
        BookshelfFixtureLoader bookshelf, path.resolve __dirname, 'fixtures', 'unsupported.csv'
        return
      assert.throws bfl, Error, 'Unsupported format: .csv'

  return