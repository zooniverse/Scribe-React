React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

DEBUG = false

module.exports = 

######################################

ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'

  render: ->
    <div className="image-subject-viewer">
      <h1>Image Subject Viewer</h1>
      <SubjectContainer endpoint="https://api.zooniverse.org/projects/galaxy_zoo/groups/50251c3b516bcb6ecb000002/subjects?limit=5" />
      <ActionButton />
      <Link to="root">Go back to main page...</Link>
    </div>

######################################

SubjectContainer = React.createClass
  displayName: 'SubjectContainer'

  getInitialState: ->
    subjects: example_subjects
    subject_img_url: "http://sierrafire.cr.usgs.gov/images/loading.gif"


  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->
    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->
        @setState subjects: data
        @setState subject_img_url: data[0].location.standard
        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return

  selectSubject: ->

  showNextImage: ->
    return #if @state.subj_idx < @state.subj_count
    
  render: ->
    <div className="subject-container">
      <h3>This is the image</h3>
      <SubjectImage url={@state.subject_img_url} />
    </div>

######################################

SubjectImage = React.createClass

  render: ->
    <img src={@props.url} />

ActionButton = React.createClass
  displayName: "ActionButton"

  getInitialState: ->
    label: "NEXT"

  handleSubmit: (e) ->
    e.preventDefault() # prevent browser's default submit action
    console.log 'idx: ', @state.idx

  render: ->
    <form onSubmit={@handleSubmit}>
      <input type="submit" className="action-button" value={@state.label} />
    </form>

window.React = React