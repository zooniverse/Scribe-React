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
    console.log "INITIAL (STATE.X, STATE.Y): (#{@props.mark.x},#{@props.mark.y})"
    centerX: @props.mark.x
    centerY: @props.mark.y
    markHeight: @props.defaultMarkHeight
    fillColor: 'rgba(0,0,0,0.5)'
    strokeColor: '#26baff'
    strokeWidth: 3
    offset: 0
    yUpper: @props.mark.y - @props.defaultMarkHeight/2
    yLower: @props.mark.y + @props.defaultMarkHeight/2

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
    {x,y} = @props.getEventOffset(e)
    @setState 
      centerX: x
      centerY: y
    console.log "UPDATED MARK CENTER: #{@state.centerY}"

  handleUpperResize: (e) ->
    {x,y} = @props.getEventOffset e

    @setState
      offset: Math.round( y-@state.centerY+@state.markHeight/2 )
      markHeight: Math.round( Math.abs( @state.markHeight - @state.offset ) )
      yUpper: y
      # yLower: Math.abs( y + @state.markHeight )
    
    # DEBUG CODE
    # NOTE: yUpper and yLower are the same (refactor?)
    console.log 'MARK CENTER             : ', @state.centerY
    console.log '[yUpper,yLower]         : ', "[#{@state.yUpper},#{@state.yLower}]"
    console.log 'DIST. CENTER (UPPER)    : ', @state.yUpper - @state.centerY
    # console.log 'DIST. CENTER (LOWER)    : ', @state.yLower - @state.centerY
    console.log 'MARK HEIGHT             : ', @state.markHeight
    console.log 'OFFSET                  : ', @state.offset
    console.log '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< HANDLE UPPER RESIZE()'

  handleLowerResize: (e) ->
    {x,y} = @props.getEventOffset e

    @setState
      offset: Math.round( y-@state.centerY-@state.markHeight/2 )
      markHeight: Math.round( Math.abs( @state.markHeight + @state.offset ) )
      # yUpper: y
      yLower: Math.abs( y + @state.markHeight )
    
    # DEBUG CODE
    # NOTE: yUpper and yLower are the same (refactor?)
    console.log 'MARK CENTER             : ', @state.centerY
    console.log '[yUpper,yLower]         : ', "[#{@state.yUpper},#{@state.yLower}]"
    # console.log 'DIST. CENTER (UPPER)    : ', @state.yUpper - @state.centerY
    console.log 'DIST. CENTER (LOWER)    : ', @state.yLower - @state.centerY
    console.log 'MARK HEIGHT             : ', @state.markHeight
    console.log 'OFFSET                  : ', @state.offset
    console.log '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< HANDLE LOWER RESIZE()'

  render: ->
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
      transform = {"translate(0, #{@state.centerY-@state.markHeight/2})"} 
      data-disabled = {@props.disabled || null} 
      data-selected = {@props.selected || null}
    >

      <Draggable
        onStart = {@props.select.bind null, @props.mark} 
        onDrag = {@handleDrag} >
        <rect 
          className   = "mark-rectangle"
          x           = 0
          y           = 0
          viewBox     = {"0 0 @props.imageWidth @props.imageHeight"}
          width       = {@props.imageWidth}
          height      = {@state.markHeight}
          fill        = {"rgba(0,0,0,0.5)"}
          stroke      = {@state.strokeColor}
          strokeWidth = {@state.strokeWidth}
          transform   = {"translate(0,#{@state.offset})"}
        />
      </Draggable>

      <ResizeButton 
        className = "upperResize"
        handleResize = {@handleUpperResize} 
        transform = {"translate( #{@props.imageWidth/2}, #{ @state.offset - @props.scrubberHeight/2 } )"} 
        scrubberHeight = {@props.scrubberHeight}
        scrubberWidth = {@props.scrubberWidth}
      />

      <ResizeButton 
        className = "lowerResize"
        handleResize = {@handleLowerResize} 
        transform = {"translate( #{@props.imageWidth/2}, #{ @state.offset + Math.round(@state.markHeight) - @props.scrubberHeight/2 } )"} 
        scrubberHeight = {@props.scrubberHeight}
        scrubberWidth = {@props.scrubberWidth}
      />

      {deleteButton}
    </g>
  