# @cjsx React.DOM

React = require 'react'
Draggable = require '../lib/draggable'

module.exports = React.createClass
  displayName: 'ResizeButton'

  handleDrag: (e) ->
    console.log 'BAR ', e
    @props.handleTopResize()

  render: ->

    fillColor = '#26baff'
    strokeColor = '#000'
    strokeWidth = 1
    width = 32
    height = 16
  
    <Draggable 
      onStart = {@props.handleResize} 
      onDrag = {@props.handleResize} 
    >
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
