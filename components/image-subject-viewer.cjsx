# @cjsx React.DOM

React                         = require 'react'
{Router, Routes, Route, Link} = require 'react-router'
example_subjects              = require '../lib/example_subject.json'
$                             = require '../lib/jquery-2.1.0.min.js'

SVGImage                      = require './svg-image'
Draggable                     = require '../lib/draggable'
LoadingIndicator              = require './loading-indicator'
SubjectMetadata               = require './subject-metadata'
ActionButton                  = require './action-button'

######################################

annotations = []

ImageSubjectViewer = React.createClass
  displayName: 'ImageSubjectViewer'

  render: ->
    endpoint = "http://localhost:3000/workflows/533cd4dd4954738018030000/subjects.json?limit=5"
    <div className="image-subject-viewer">
      <SubjectViewer ref='subject_container' endpoint=endpoint />
    </div>


SubjectViewer = React.createClass
  displayName: 'SubjectViewer'

  getInitialState: ->
    subjects: example_subjects # TODO: need to remove this

    loading: false

    frame: 0
    imageWidth: 0
    imageHeight: 0

    viewX: 0
    viewY: 0
    viewWidth: 0
    viewHeight: 0

    selectedMark: null # TODO: currently not in use

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
            imageWidth: img.width
            imageHeight: img.height
            loading: false #, =>
            # console.log @state.loading
            # console.log "Finished Loading."


  nextSubject: () ->
      if @state.subjects.shift() is undefined or @state.subjects.length <= 0
        @fetchSubjects()
        return
      else
        @loadImage @state.subjects[0].location

      console.log 'NEXT IMAGE: ', @state.subject1s[0].location # DEBUG CODE

  handleInitStart: (e) ->
    console.log 'handleInitStart()'

    mouseCoords = @getEventOffset e
    annotation = annotations[annotations.length - 1]
    annotation.marks ?= []
    mark = annotation.marks[annotation.marks.length - 1]
    MarkComponent = drawingComponents[@props.selectedDrawingTool.type]

    if MarkComponent.isComplete?
      incomplete = not MarkComponent.isComplete? mark

    unless incomplete
      mark =
        _id: Math.random()
        _tool: @props.selectedDrawingTool
        _releases: 0

      if MarkComponent.defaultValues?
        defaultValues = MarkComponent.defaultValues mouseCoords
        for key, value of defaultValues
          mark[key] = value


    # TODO: I don't entirely trust that the action always fires immediately.
    # There should probably be a one-time listener here on the classification.

    @setState selectedMark: annotation.marks[annotation.marks.length - 1], =>
      mark = @state.selectedMark
      if MarkComponent.initStart?
        initProps = MarkComponent.initStart mouseCoords, e


  handleInitDrag: (e) ->
    console.log 'handleInitDrag()'

  handleInitRelease: (e) ->
    console.log 'handleInitRelease()'


  setView: (viewX, viewY, viewWidth, viewHeight) ->
    @setState {viewX, viewY, viewWidth, viewHeight}

  getScale: ->
    rect = @refs.sizeRect?.getDOMNode().getBoundingClientRect()
    rect ?= width: 0, height: 0
    horizontal: rect.width / @state.viewWidth
    vertical: rect.height / @state.viewHeight

  getEventOffset: (e) ->
    rect = @refs.sizeRect.getDOMNode().getBoundingClientRect()
    {horizontal, vertical} = @getScale()
    x: ((e.pageX - pageXOffset - rect.left) / horizontal) + @state.viewX
    y: ((e.pageY - pageYOffset - rect.top) / vertical) + @state.viewY

  selectMark: (mark) ->
    annotation = annotations[annotations.length - 1]
    index = annotation.marks?.indexOf mark
    if index? and index isnt -1
      annotation.marks.splice index, 1
      annotation.marks.push mark
      @setState selectedMark: mark
    
  render: ->

    viewBox = [0, 0, @state.imageWidth, @state.imageHeight]

    # console.log 'RENDER! =-=-=-=-=-=-=-=-=-=-=-=-'
    # console.log 'url: ', @state.subjects[0].location
    # console.log 'VIEWBOX: ', viewBox

    if @state.loading
      <div className="subject-container">
        <div className="marking-surface">
          <LoadingIndicator />
        </div>       
        <p>{@state.subjects[0].location}</p>
        <div className="subject-ui">
          <ActionButton onActionSubmit={@nextSubject} loading={@state.loading} />
        </div>
      </div>

    else
      <div className="subject-container">
        <div className="marking-surface">
          <svg className="subject-viewer-svg" width={@state.imageWidth} height={@state.imageHeight} viewBox={viewBox} data-tool={@props.selectedDrawingTool?.type}>
            <rect ref="sizeRect" width={@state.imageWidth} height={@state.imageHeight} />
            <Draggable onStart={@handleInitStart} onDrag={@handleInitDrag} onEnd={@handleInitRelease}>
              <SVGImage src={@state.subjects[0].location} width={@state.imageWidth} height={@state.imageHeight} />
            </Draggable>
          </svg>
        </div>

        <p>{@state.subjects[0].location}</p>
        <div className="subject-ui">
          <ActionButton onActionSubmit={@nextSubject} loading={@state.loading} />
        </div>
      </div>

module.exports = ImageSubjectViewer
window.React = React
window.foo = ImageSubjectViewer
