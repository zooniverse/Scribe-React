# @cjsx React.DOM
# Model = require '../../data/model'
React = require 'react'
Draggable = require '../lib/draggable'
DeleteButton = require './delete-button'
# {dispatch} = require '../../lib/dispatcher'

module.exports = React.createClass
  displayName: 'PointTool'

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

  updateMark: (e) ->
    console.log 'updateMark() ', e
    @setState
      x: e.x
      y: e.y

  render: ->
    
    fillColor   = 'rgba(0,0,0,0.5)'
    strokeColor = '#fff'
    radius = 40

    # radius = if @props.disabled
    #   4
    # else if @props.selected
    #   12
    # else
    #   6

    strokeWidth = 5

    console.log "RENDERING (#{@props.mark.x},#{@props.mark.y})"

    transform = "
      translate(#{@state.x}, #{@state.y})
      scale(#{1}, #{1})
    "

    # transform = "
    #   translate(#{@props.mark.x}, #{@props.mark.y})
    #   scale(#{1 / @props.scale.horizontal}, #{1 / @props.scale.vertical})
    # "

    <g className="point drawing-tool" transform={transform} data-disabled={@props.disabled || null} data-selected={@props.selected || null}>
      <Draggable onStart={@props.select} onDrag={@handleDrag}>
        <g strokeWidth={strokeWidth}>
          <circle r={radius + (strokeWidth / 2)} stroke={strokeColor} fill={fillColor} />
        </g>
      </Draggable>
      <DeleteButton transform="translate(#{radius}, #{-1 * radius})" onClick={@deleteMark} />

    </g>


  handleDrag: (e) ->
    console.log 'handleDrag()'
    console.log 'getEventOffset ', @props.getEventOffset(e)
    @updateMark e
  #   dispatch 'classification:annotation:mark:update', @props.mark, @props.getEventOffset e

  deleteMark: ->
    console.log 'deleteMark()'
  #   dispatch 'classification:annotation:mark:delete', @props.mark
