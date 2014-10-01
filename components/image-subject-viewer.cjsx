React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

module.exports = 

# the top-level component
ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'

  render: ->
    <div className="image-subject-viewer">
      <h1>Image Subject Viewer</h1>
      <ImageContainer />
      <MarkingSurface />
      <Link to="root">Go back.</Link>
    </div>

ImageContainer = React.createClass
  displayName: 'ImageContainer'
  render: ->
    <div>
      <h3>This is the image</h3>
      <img src={example_subjects[0].location.standard} />
    </div>

MarkingSurface = React.createClass
  displayName: 'MarkingSurface'
  render: ->
    <div>
      <h3>This is the marking surface</h3>
    </div>

Subject = React.createClass
  displayName: 'Subject'
  render: ->
    return
  loadCommentsFromServer: ->
    return
    $.ajax
      url: "https://api.zooniverse.org/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects?limit=5"
      dataType: "json"
      success: ((data) ->
        @setState data: data
        return
      ).bind(this)
      # error: ((xhr, status, err) ->
      #   console.error @props.url, status, err.toString()
      #   return
      # ).bind(this)
    return
  getInitialState: ->
    data: []
  # componentDidMount: ->
  #   @loadCommentsFromServer()
  #   setInterval @loadCommentsFromServer, @props.pollInterval
  #   return


window.React = React