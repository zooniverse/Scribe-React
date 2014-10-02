React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

module.exports = 

######################################

ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'
  nextSubject:->
    @refs.subcontainer.updateMe()

  render: ->
    endpoint = "http://localhost:3000/workflows/533cd4dd4954738018030000/subjects.json?limit=10"
    <div className="image-subject-viewer">
      <h1>Image Subject Viewer</h1>
      <SubjectContainer ref='subcontainer' endpoint=endpoint />
      <ActionButton onActionSubmit={@nextSubject} />
      <Link to="root">Go back to main page...</Link>
    </div>

######################################

SubjectContainer = React.createClass
  displayName: 'SubjectContainer'

  getInitialState: ->
    subjects: example_subjects
    subject_img_url: "http://sierrafire.cr.usgs.gov/images/loading.gif"
    meta_data: "Blah"

  updateMe: ->
    @selectNextSubject()

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->
    @setState subject_img_url: "http://sierrafire.cr.usgs.gov/images/loading.gif"

    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->
        @setState subjects        : data
        @setState curr_subject    : data[0]
        @setState subject_img_url : data[0].location
        @setState meta_data       : data[0].meta_data

        # pre-load images
        for subject, i in data
          tmp = new Image()
          tmp.src = subject.location 

        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return


  selectNextSubject: () ->
    if @state.subjects.shift() is undefined or @state.subjects.length <= 0
      @fetchSubjects()
      return
    else
      @setState curr_subject: @state.subjects[0]
      @setState subject_img_url: @state.subjects[0].location
      @setState meta_data: @state.subjects[0].meta_data
    
  render: ->
    <div className="subject-container">
      <SubjectImage url={@state.subject_img_url} />
      <SubjectMetadata id={@state.subjects[0].zooniverse_id} meta_data={@state.meta_data} />
    </div>

######################################

SubjectImage = React.createClass
  render: ->
    <img src={@props.url} />

######################################

SubjectMetadata = React.createClass

  render: ->
    <div className="subject-meta_data">
      <h3>Metadata</h3>
    </div>

######################################

ActionButton = React.createClass
  displayName: "ActionButton"

  getInitialState: ->
    label: "NEXT SUBJECT"
    disable: true

  handleSubmit: (e) ->
    e.preventDefault() # prevent browser's default submit action
    @props.onActionSubmit()

  render: ->
    <form onSubmit={@handleSubmit}>
      <input type="submit" className="action-button" value={@state.label} />
    </form>

window.React = React