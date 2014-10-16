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
PointTool                     = require './point'

annotations = []
marks = []

ImageSubjectViewer = React.createClass # rename to Classifier
  displayName: 'ImageSubjectViewer'

  render: ->
    endpoint = "http://localhost:3000/workflows/533cd4dd4954738018030000/subjects.json?limit=5"
    <div className="image-subject-viewer">
      <SubjectViewer endpoint=endpoint />
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
    @setView 0, 0, @state.imageWidth, @state.imageHeight
    @fetchSubjects()

  fetchSubjects: ->
    $.ajax
      url: @props.endpoint
      dataType: "json"
      success: ((data) ->

        # DEBUG CODE
        # console.log 'FETCHED SUBJECTS: ', subject.location for subject in data

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
    {horizontal, vertical} = @getScale()
    rect = @refs.sizeRect?.getDOMNode().getBoundingClientRect()
    {x, y} = @getEventOffset e
    marks.push {x, y}
    @selectMark marks[length-1]

    @forceUpdate()

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
    
    # console.log 'RECT: ', rect
    # {horizontal, vertical} = @getScale()
    # x: ((e.pageX - pageXOffset - rect.left) / horizontal) + @state.viewX
    # y: ((e.pageY - pageYOffset - rect.top) / vertical) + @state.viewY

    x: ((e.pageX - pageXOffset - rect.left)) + @state.viewX
    y: ((e.pageY - pageYOffset - rect.top)) + @state.viewY

  handleToolMouseDown: ->
    console.log 'handleToolMouseDown()'

  selectMark: (mark) ->
    console.log 'selectMark()'
    @setState selectedMark: mark

    @forceUpdate()

    # index = marks?.indexOf mark
    # if index? and index isnt -1
    #   marks.splice index, 1
    #   marks.push mark
    #   @setState selectedMark: mark

  onClickDelete: (e, key) ->
    console.log "dleeeet: ", e.target

  render: ->
    console.log 'SELECTED MARK: ', @state.selectedMark

    tools = []

    for mark, key in [ marks... ]
      tools.push new PointTool
        mark: mark
        key: key
        disabled: false
        selected: mark is @state.selectedMark
        select: @selectMark.bind null, mark
        getEventOffset: @getEventOffset
        onClickDelete: @onClickDelete  
        imageWidth: @state.imageWidth
        imageHeight: @state.imageHeight

    viewBox = [0, 0, @state.imageWidth, @state.imageHeight]

    if @state.loading
      <div className="subject-container">
        <div className="marking-surface">
          <LoadingIndicator/>
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
            <g className="subject-viewer-tools" onMouseDown={@handleToolMouseDown}>
              {tools}
            </g>
          </svg>
        </div>
        <p>{@state.subjects[0].location}</p>
        <div className="subject-ui">
          <ActionButton onActionSubmit={@nextSubject} loading={@state.loading} />
        </div>
      </div>

module.exports = ImageSubjectViewer
window.React = React
