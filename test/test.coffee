path = require 'path'

assert = require('chai').assert

knex = require('knex')
  client: 'sqlite3'
  connection:
    filename: ':memory:'
  useNullAsDefault: yes

bookshelf = require('bookshelf') knex
bookshelf.plugin 'registry'

FixtureLoader = require('../src') bookshelf, __dirname
fixtures = new FixtureLoader()

Model = bookshelf.model 'Test',
  tableName: 'test'

before () ->
  knex.schema.createTableIfNotExists 'test', (table) ->
    table.increments()
    table.string 'name'
    return

beforeEach () ->
  knex('test').del()

describe 'FixtureLoader', () ->
  describe 'should load fixtures from', () ->
    it 'JSON file', () ->
      fixtures.clean().add 'test.json'
      .insert()
      .then () -> Model.forge(id: 1).fetch()
      .then (row) ->
        assert.equal row.get('name'), 'test 1'
        return

    it 'YAML file', () ->
      fixtures.clean().add 'test.yaml'
      .insert()
      .then () -> Model.forge(id: 2).fetch()
      .then (row) ->
        assert.equal row.get('name'), 'test 2'
        return

    it 'many files', () ->
      fixtures.clean().add ['test.json', 'test.yaml']
      .insert()
      .then () -> Model.count()
      .then (cnt) ->
        assert.equal cnt, 2
        return

    it 'file with absolute path', () ->
      fixtures.clean().add path.resolve(__dirname, 'fixtures', 'test.yaml')
      .insert()
      .then () -> Model.forge(id: 2).fetch()
      .then (row) ->
        assert.equal row.get('name'), 'test 2'
        return

    it 'many files with mixed format (absolute path and relative path)', () ->
      fixtures.clean().add('test.json').add(path.resolve(__dirname, 'fixtures', 'test.yaml'))
      .insert()
      .then () -> Model.count()
      .then (cnt) ->
        assert.equal cnt, 2
        return

  describe 'should throw Error', () ->
    it 'when cannot find module', () ->
      bfl = () ->
        fixtures.clean().add 'no_module.yaml'
        return
      assert.throws bfl, Error, 'Undefined model: NonExistent'

    it 'when use unsupported format', () ->
      bfl = () ->
        fixtures.clean().add 'unsupported.csv'
        return
      assert.throws bfl, Error, 'Unsupported format: .csv'

  return
