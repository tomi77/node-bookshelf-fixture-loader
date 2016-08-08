path = require 'path'

jsonFile = require 'jsonfile'
YAML = require 'yamljs'

isArray = require 'lodash/isArray'


module.exports = (bookshelf, fixtureFileNames) ->
  fixtureFileNames = [fixtureFileNames] unless isArray fixtureFileNames

  for fixtureFileName in fixtureFileNames
    ext = path.extname fixtureFileName

    fixtures = switch ext
      when '.json'
        jsonFile.readFileSync fixtureFileName
      when '.yml', '.yaml'
        YAML.load fixtureFileName
      else
        throw new Error "Unsupported format: #{ ext }"

    for fixture in fixtures
      Model = bookshelf.model fixture.model
      unless Model?
        throw new Error "Undefined model: #{ fixture.model }"

      new Model id: fixture.id
      .save fixture.fields, method: 'insert'
