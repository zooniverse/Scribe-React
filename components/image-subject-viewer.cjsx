# @cjsx React.DOM

React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

MarkingSurface                = require './marking-surface'
SubjectMetadata               = require './subject-metadata'
ActionButton                  = require './action-button'

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

  componentDidMount: ->
    @fetchSubjects()

  fetchSubjects: ->
    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->

        # DEBUG CODE
        console.log 'FETCHED SUBJECTS: ', subject.location for subject in data

        @setState subjects: data, =>
          @loadImage @state.subjects[0].location

        # console.log 'Fetched Images.' # DEBUG CODE

        return
      ).bind(this)
      error: ((xhr, status, err) ->
        console.error "Error loading subjects: ", @props.endpoint, status, err.toString()
        return
      ).bind(this)
    return

  loadImage: (url) ->    
    # console.log 'Loading image...' # DEBUG CODE
    @setState loading: true, =>
      img = new Image()
      img.src = url
      img.onload = =>
        if @isMounted()
          @setState 
            url: url
            imgWid: img.width
            imgHei: img.height
            loading: false #, =>
            # console.log @state.loading
            # console.log "Finished Loading."

          console.log "wid = #{img.width}, hei = #{img.height}"

  nextSubject: () ->
      if @state.subjects.shift() is undefined or @state.subjects.length <= 0
        @fetchSubjects()
        return
      else
        @loadImage @state.subjects[0].location

      console.log 'NEXT IMAGE: ', @state.subjects[0].location # DEBUG CODE
    
  render: ->
    console.log 'url: ', @state.subjects[0].location
    <div className="subject-container">


      <MarkingSurface url={@state.subjects[0].location} loading={@state.loading} wid={@state.imgWid} hei={@state.imgHei} />
      

      <p>{@state.subjects[0].location}</p>
      <div className="subject-ui">
        <ActionButton onActionSubmit={@nextSubject} loading={@state.loading} />
      </div>
    </div>


module.exports = ImageSubjectViewer
window.React = React
