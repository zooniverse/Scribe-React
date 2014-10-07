# @cjsx React.DOM

React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

MarkingSurface                = require './marking-surface'


######################################

ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'

  render: ->
    endpoint = "http://localhost:3000/workflows/533cd4dd4954738018030000/subjects.json?limit=5"
    <div className="image-subject-viewer">
      <SubjectContainer ref='subject_container' endpoint=endpoint />
    </div>

######################################

SubjectContainer = React.createClass
  displayName: 'SubjectContainer'

  getInitialState: ->
    subjects: example_subjects
    meta_data: "Blah"

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->
    @setState loading: true
    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->

        console.log 'FETCHED SUBJECTS: ', subject.location for subject in data

        @setState 
          subjects        : data
          curr_subject    : data[0]
          subject_img_url : data[0].location
          meta_data       : data[0].meta_data

        # pre-load images
        for subject, i in data
          img = new Image()
          img.src = subject.location 

        console.log 'Finished Loading.'

        @setState loading: false, =>
          console.log @state.loading

        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return

  nextSubject: () ->
    @setState loading: true, =>
      if @state.subjects.shift() is undefined or @state.subjects.length <= 0
        @fetchSubjects()
        return
      else
        @setState curr_subject: @state.subjects[0]
        @setState subject_img_url: @state.subjects[0].location
        @setState meta_data: @state.subjects[0].meta_data

        img = new Image()
        img.src = @state.subjects[0].location
        img.onload = =>
          if @isMounted()
            @setState loading: false #, =>
              # console.log @state.loading
              # console.log "Finished Loading."



      console.log 'NEXT IMAGE: ', @state.subject_img_url
    
  render: ->
    <div className="subject-container">
      <MarkingSurface url={@state.subject_img_url} loading={@state.loading} />
      <div className="subject-ui">
        <SubjectMetadata id={@state.subjects[0].zooniverse_id} meta_data={@state.meta_data} />
        <ActionButton onActionSubmit={@nextSubject} />
      </div>
    </div>


######################################

SubjectMetadata = React.createClass
  displayName: "Metadata"

  render: ->
    <div className="metadata">
      <h3>Metadata</h3>
    </div>

######################################

ActionButton = React.createClass
  displayName: "ActionButton"

  getInitialState: ->
    label: "NEXT SUBJECT"
    disable: true

  handleSubmit: (e) ->
    console.log 'ACTION'
    e.preventDefault() # prevent browser's default submit action
    @props.onActionSubmit()

  render: ->
    <form onSubmit={@handleSubmit}>
      <input type="submit" className="action-button button" value={@state.label} />
    </form>

module.exports = ImageSubjectViewer
window.React = React
