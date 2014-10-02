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
    metadata: "Blah"

  updateMe: ->
    @selectNextSubject()

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->

    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->
        @setState subjects        : data
        @setState curr_subject    : data[0]
        @setState subject_img_url : data[0].location.standard
        @setState metadata        : data[0].metadata

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
      @setState subject_img_url: @state.subjects[0].location.standard
      @setState metadata: @state.subjects[0].metadata
    
  render: ->
    <div className="subject-container">
      <SubjectImage url={@state.subject_img_url} />
      <SubjectMetadata id={@state.subjects[0].zooniverse_id} metadata={@state.metadata} />
    </div>

######################################

SubjectImage = React.createClass
  render: ->
    <img src={@props.url} />

######################################

SubjectMetadata = React.createClass

  render: ->
    <div className="subject-metadata">
      <h3>Metadata</h3>
      <ul>
        <li>
          <span classname="meta-field">ID: </span> 
          <span className="meta-value">{@props.id}</span>
        </li>
        <li>
          <span classname="meta-field">Absolute Size: </span> 
          <span className="meta-value">{@props.metadata.absolute_size}</span> 
        </li>
        <li>
          <span classname="meta-field">Red Shift: </span> 
          <span className="meta-value">{@props.metadata.redshift}</span> 
        </li>
      </ul>
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