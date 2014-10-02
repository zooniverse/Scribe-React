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
    metadata: "Blah"

  updateMe: ->
    @selectNextSubject()

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->
    if DEBUG
      console.log 'Fetching subjects...'

    # @setState subject_img_url : "http://sierrafire.cr.usgs.gov/images/loading.gif"


    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->
        @setState subjects        : data
        @setState curr_subject    : data[0]
        @setState subject_img_url : data[0].location.standard
        @setState metadata        : data[0].metadata

        for subject, i in data
          console.log 'SUBJECT ID: ', subject.zooniverse_id

        console.log 'CURRENT SUBJECT: ', @state.curr_subject.zooniverse_id
        console.log 'SUBJECTS: ', @state.subjects

        console.log 'STATE: ', @state

        # @selectNextSubject()

        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return

  selectNextSubject: () ->
    console.log "selectNextSubject()"
    console.log "***************************************"
    console.log 'SUBJECTS: ', @state.subjects

    if @state.subjects.shift() is undefined or @state.subjects.length <= 0
      console.log 'ran out of subjects. fetching more...'
      @fetchSubjects()
      return
    else
      console.log 'STATE: ', @state

      @setState curr_subject: @state.subjects[0]
      @setState subject_img_url: @state.subjects[0].location.standard
      @setState metadata: @state.subjects[0].metadata


  
    console.log 'CURRENT SUBJECT: ', @state.subjects[0].zooniverse_id
    
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
    console.log 'PROP.METADATA: ', @props.metadata
    <div className="subject-metadata">
      <h3>Metadata</h3>
      <ul>
        <li>ID: {@props.id}</li>
        <li>Absolute Size: {@props.metadata.absolute_size}</li>
        <li>Red Shift: {@props.metadata.redshift}</li>
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