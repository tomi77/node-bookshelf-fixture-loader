path = require 'path'
jsonFile = require 'jsonfile'
YAML = require 'yamljs'
isArray = require 'lodash/isArray'
extend = require 'lodash/extend'

module.exports = (bookshelf, fixtureFileNames) ->
  fixtureFileNames = [fixtureFileNames] unless isArray fixtureFileNames

  for fixtureFileName in fixtureFileNames
    ext = path.extname fixtureFileName
    fixtures = switch ext
      when '.json' then jsonFile.readFileSync fixtureFileName
      when '.yml', '.yaml' then YAML.load fixtureFileName
      else
        throw new Error "Unsupported format: #{ ext }"

    for fixture in fixtures
      Model = bookshelf.model fixture.model
      unless Model?
        throw new Error "Undefined model: #{ fixture.model }"

      new Model extend fixture.fields, id: fixture.id
      .save null, method: 'insert'
