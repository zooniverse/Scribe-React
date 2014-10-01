React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

DEBUG = false

module.exports = 

# the top-level component
ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'

  render: ->
    <div className="image-subject-viewer">
      <h1>Image Subject Viewer</h1>
      <SubjectContainer endpoint="https://api.zooniverse.org/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects?limit=5" />
      <MarkingSurface />
      <ActionButton />
      <Link to="root">Go back.</Link>
    </div>

SubjectContainer = React.createClass
  displayName: 'SubjectContainer'

  getInitialState: ->
    subjects: example_subjects

  componentDidMount: ->
    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->
        @setState subjects: data
        @setState subj_count: data.length
        @setState subj_curr: 0
        if DEBUG
          console.log "LOADED SUBJECTS #{@state.subj_count}:", data
          console.log "SETTING CURRENT SUBJECT TO #{@state.subj_curr}"
        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return

  showNextImage: ->
    return if @state.subj_curr < @state.subj_count
    @setState


  render: ->
    <div>
      <h3>This is the image</h3>
      <SubjectImage url={@state.subjects[0].location.standard} />
    </div>

SubjectImage = React.createClass
  getInitialState: ->
    null

  render: ->
    <img src={@props.url} />

ActionButton = React.createClass
  displayName: "ActionButton"

  getInitialState: ->
    label: "NEXT"
  render: ->
    <button className="action-button">{@state.label}</button>

# NOT BEING USED (YET!)
MarkingSurface = React.createClass
  displayName: 'MarkingSurface'
  render: ->
    <div>
      <h3>This is the marking surface</h3>
    </div>

window.React = React