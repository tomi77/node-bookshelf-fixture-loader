path = require 'path'

assert = require('chai').assert

knex = require('knex')
  client: 'sqlite3'
  connection:
    filename: ':memory:'
  useNullAsDefault: yes

bookshelf = require('bookshelf') knex
bookshelf.plugin 'registry'

BookshelfFixtureLoader = require('../src') bookshelf, __dirname

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
      BookshelfFixtureLoader 'test.json'

      Model = bookshelf.model('Test')
      Model.forge(id: 1).fetch().then (row) ->
        assert.equal row.get('name'), 'test 1'
        return

    it 'YAML file', () ->
      BookshelfFixtureLoader 'test.yaml'

      Model = bookshelf.model('Test')
      Model.forge(id: 2).fetch().then (row) ->
        assert.equal row.get('name'), 'test 2'
        return

    it 'many files', () ->
      BookshelfFixtureLoader ['test.json', 'test.yaml']

      Model = bookshelf.model('Test')
      Model.count().then (cnt) ->
        assert.equal cnt, 2
        return

    it 'file with absolute path', () ->
      BookshelfFixtureLoader path.resolve(__dirname, 'fixtures', 'test.yaml')

      Model = bookshelf.model('Test')
      Model.forge(id: 2).fetch().then (row) ->
        assert.equal row.get('name'), 'test 2'
        return

    it 'many files with mixed format (absolute path and relative path)', () ->
      BookshelfFixtureLoader ['test.json', path.resolve(__dirname, 'fixtures', 'test.yaml')]

      Model = bookshelf.model('Test')
      Model.count().then (cnt) ->
        assert.equal cnt, 2
        return

  describe 'should throw Error', () ->
    it 'when cannot find module', () ->
      bfl = () ->
        BookshelfFixtureLoader 'no_module.yaml'
        return
      assert.throws bfl, Error, 'Undefined model: NonExistent'

    it 'when use unsupported format', () ->
      bfl = () ->
        BookshelfFixtureLoader 'unsupported.csv'
        return
      assert.throws bfl, Error, 'Unsupported format: .csv'

  return
