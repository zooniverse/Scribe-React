# @cjsx React.DOM
# Model = require '../../data/model'
React = require 'react'
Draggable = require '../lib/draggable'
DeleteButton = require './delete-button'
ResizeButton = require './resize-button'

module.exports = React.createClass
  displayName: 'TextRegionTool'

  statics:
    defaultValues: ->
      @initStart arguments...

    initStart: ->
      @initMove arguments...

    initMove: ({x, y}) ->
      {x, y}

  getInitialState: ->
    x: @props.mark.x
    y: @props.mark.y
    markHeight: 100
    radius: 40
    fillColor: 'rgba(0,0,0,0.5)'
    strokeColor: '#26baff'
    strokeWidth: 3
    topYOffset: 0
    bottomYOffset: 0

  updateMark: ({x,y}) ->
    # console.log 'updateMark() ', e
    @setState {x,y}

  handleMouseOver: ->
    console.log 'onMouseOver()'
    @setState 
      strokeColor: '#fff'
      fillColor: 'rgba(0,0,0,0.25)'

  handleMouseOut: ->
    console.log 'onMouseOut()'
    @setState 
      strokeColor: 'rgba(255,255,255,0.75)'
      fillColor: 'rgba(0,0,0,0.5)'

  handleDrag: (e) ->
    @updateMark @props.getEventOffset(e)
  
  handleTopResize: (e) ->
    console.log 'TextRegion: handleTopResize()'
    console.log "   CLICKED ON: (#{e.x},#{e.y})"
    {x,y} = @props.getEventOffset e
    @setState
      topYOffset: y-@state.y+50
    console.log "   DRAGGED TO (#{x},#{y}): topYOffset = ", @state.topYOffset

  handleBottomResize: (e) ->
    console.log 'TextRegion: handleBottomResize()'
    console.log "   CLICKED ON: (#{e.x},#{e.y})"
    {x,y} = @props.getEventOffset e
    @setState
      bottomYOffset: y-@state.y-50
    console.log "   DRAGGED TO (#{x},#{y}): bottomYOffset = ", @state.bottomYOffset


  handleMouseDown: ->
    console.log 'MOUSE DOWN. CALL FOR BACKUP!'

  foo: ->
    console.log 'BAR'

  render: ->
    transform = "
      translate(#{@state.x}, #{@state.y})
      scale(#{1}, #{1})
    "

    topResizeTransform = "translate(#{@props.imageWidth/2}, #{0-16/2+@state.topYOffset})"
    bottomResizeTransform = "translate(#{@props.imageWidth/2}, #{@state.markHeight-16/2+@state.bottomYOffset})"

    if @props.selected
      deleteButton = 
        <DeleteButton 
          transform = "translate(25, #{@state.markHeight/2})" 
          onClick = {@props.onClickDelete.bind null, @props.key} 
        />
    else
      deleteButton = null

    <g 
      className = "point drawing-tool" 
      transform = {"translate(0, #{@state.y-@state.markHeight/2})"} 
      data-disabled = {@props.disabled || null} 
      data-selected = {@props.selected || null}
    >
      <Draggable 
        onStart = {@props.select} 
        onDrag = {@handleDrag} >
        <rect 
          x           = 0
          y           = 0
          viewBox     = {"0 0 @props.imageWidth @props.imageHeight"}
          width       = {@props.imageWidth}
          height      = {"100"}
          fill        = {"rgba(0,0,0,0.5)"}
          stroke      = {@state.strokeColor}
          strokeWidth = {@state.strokeWidth}
        />
      </Draggable>

      <ResizeButton 
        handleResize = {@handleTopResize} 
        transform = {topResizeTransform} 
      />

      <ResizeButton 
        handleResize = {@handleBottomResize} 
        transform = {bottomResizeTransform} 
      />

      {deleteButton}
    </g>
  