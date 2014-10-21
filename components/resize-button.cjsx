# @cjsx React.DOM

React = require 'react'
Draggable = require '../lib/draggable'

module.exports = React.createClass
  displayName: 'ResizeButton'

  handleMouseDown: (e) ->
    console.log 'RESIZING MARK ', @props
    @props.resizeMark e

  handleDrag: (e) ->
    console.log 'BAR ', e
    @props.handleTopResize()

  render: ->

    fillColor = '#26baff'
    strokeColor = '#000'
    strokeWidth = 2
    width = 10
    height = 5
  
    <Draggable onDrag={@handleDrag}>
      <g 
        transform = {@props.transform} 
        className = "clickable drawing-tool-resize-button" 
        stroke = {strokeColor} 
        strokeWidth = {strokeWidth} >
        
        <rect
          width={width}
          height={height} 
          fill={fillColor} 
        />
      </g>
    </Draggable>
