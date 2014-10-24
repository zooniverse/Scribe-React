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

    markHeight: @props.defaultMarkHeight
    fillColor: 'rgba(0,0,0,0.5)'
    strokeColor: '#26baff'
    strokeWidth: 3
    upperOffset: 0
    lowerOffset: 0

    yUpper: @props.mark.y - @props.defaultMarkHeight/2
    yLower: @props.mark.y + @props.defaultMarkHeight/2

  updateMark: ({x,y}) ->
    # console.log 'updateMark() ', e
    @setState 
      x: x
      y: y

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
      upperOffset: y-@state.y+@state.markHeight/2
    console.log "   UPPER SCRUBBER POSITION: ", @state.upperOffset

  handleBottomResize: (e) ->
    console.log 'TextRegion: handleBottomResize()'
    console.log "   CLICKED ON: (#{e.x},#{e.y})"
    {x,y} = @props.getEventOffset e
    @setState
      lowerOffset: y-@state.y-@state.markHeight/2
    console.log "   LOWED SCRUBBER POSITION: ", @state.lowerOffset

  render: ->

    transform = "
      translate(#{@state.x}, #{@state.y})
      scale(#{1}, #{1})
    "

    topResizeTransform = "translate(#{@props.imageWidth/2}, #{0-@props.scrubberHeight/2+@state.upperOffset})"
    bottomResizeTransform = "translate(#{@props.imageWidth/2}, #{@state.markHeight-@props.scrubberHeight/2+@state.lowerOffset})"

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
        onStart = {@props.select.bind null, @props.mark} 
        onDrag = {@handleDrag} >
        <rect 
          x           = 0
          y           = 0
          viewBox     = {"0 0 @props.imageWidth @props.imageHeight"}
          width       = {@props.imageWidth}
          height      = {@state.markHeight-@state.upperOffset+@state.lowerOffset}
          fill        = {"rgba(0,0,0,0.5)"}
          stroke      = {@state.strokeColor}
          strokeWidth = {@state.strokeWidth}
          transform   = {"translate(0,#{@state.upperOffset})"}
        />
      </Draggable>

      <ResizeButton 
        handleResize = {@handleTopResize} 
        transform = {topResizeTransform} 
        scrubberHeight = {@props.scrubberHeight}
        scrubberWidth = {@props.scrubberWidth}
      />

      <ResizeButton 
        handleResize = {@handleBottomResize} 
        transform = {bottomResizeTransform} 
        scrubberHeight = {@props.scrubberHeight}
        scrubberWidth = {@props.scrubberWidth}
      />

      {deleteButton}
    </g>
  