React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

DEBUG = true

module.exports = 

######################################

ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'
  nextSubject:->
    @refs.subcontainer.updateMe()

  render: ->
    <div className="image-subject-viewer">
      <h1>Image Subject Viewer</h1>
      <SubjectContainer ref='subcontainer' endpoint="https://api.zooniverse.org/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects?limit=5" />
      <ActionButton onActionSubmit={@nextSubject} />
      <Link to="root">Go back to main page...</Link>
    </div>

######################################

SubjectContainer = React.createClass
  displayName: 'SubjectContainer'

  getInitialState: ->
    subjects: example_subjects
    subject_img_url: "http://sierrafire.cr.usgs.gov/images/loading.gif"

  updateMe: ->
    @fetchSubjects()

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->
    if DEBUG
      console.log 'Fetching subjects...'

    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->
        @setState subjects: data
        @selectSubject()
        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return

  selectSubject: () ->
    console.log "Selecting subject..."
    if @state.subjects.length is 0
      @fetchSubjects()
      return
    @setState curr_subject: @state.subjects.shift()
    @setState subject_img_url: @state.subjects[0].location.standard
    
  render: ->
    <div className="subject-container">
      <SubjectImage url={@state.subject_img_url} />
    </div>

######################################

SubjectImage = React.createClass
  render: ->
    <img src={@props.url} />

######################################

ActionButton = React.createClass
  displayName: "ActionButton"

  getInitialState: ->
    label: "NEXT SUBJECT"
    disable: true

  handleSubmit: (e) ->
    e.preventDefault() # prevent browser's default submit action
    @props.onActionSubmit()
    console.log 'handleSubmit()'

  render: ->
    <form onSubmit={@handleSubmit}>
      <input type="submit" className="action-button" value={@state.label} />
    </form>

window.React = React