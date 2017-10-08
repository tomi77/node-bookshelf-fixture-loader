path = require 'path'

jsonFile = require 'jsonfile'
YAML = require 'yamljs'

isArray = require 'lodash/isArray'
Promise = require 'bluebird'

module.exports = (bookshelf, currentDir) ->
  class FixtureLoader
    constructor: () ->
      @models = []
      return

    add: (fileNames) ->
      fileNames = [fileNames] unless isArray fileNames
      for fixtureFileName in fileNames
        fixtures = @loadFile fixtureFileName
        _models = @prepare fixtures
        @models = @models.concat _models
      return @

    clean: () ->
      @models = []
      return @

    loadFile: (fixtureFileName) ->
      unless path.isAbsolute fixtureFileName
        fixtureFileName = path.resolve currentDir, 'fixtures', fixtureFileName

      ext = path.extname fixtureFileName

      switch ext
        when '.json'
          jsonFile.readFileSync fixtureFileName
        when '.yml', '.yaml'
          YAML.load fixtureFileName
        else
          throw new Error "Unsupported format: #{ ext }"

    prepare: (fixtures) ->
      for fixture in fixtures
        Model = bookshelf.model fixture.model
        unless Model?
          throw new Error "Undefined model: #{ fixture.model }"

        fields = fixture.fields
        fields.id = fixture.id
        new Model fields

    insert: () ->
      Promise.each @models, (model) -> model.save null, method: 'insert'

  FixtureLoader
