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
    

  render: ->

    # console.log 'resize-button PROPS: ', @props

    fillColor = '#26baff'
    strokeColor = '#000'
    strokeWidth = 2
    radius = 10

    cross = "
      M #{-radius * 0.6} 0
      L 0 #{radius * 0.6 }

      M 0 #{-radius * 0.6 }
      L #{ -radius * 0.6 } 0

      M #{radius * 0.6 } 0
      L 0 #{-radius * 0.6 }

      M 0 #{radius * 0.6 }
      L #{ radius * 0.6 } 0
    "
  
    <Draggable onDrag={@handleDrag}>
      <g 
        transform = {@props.transform} 
        className = "clickable drawing-tool-resize-button" 
        stroke = {strokeColor} 
        strokeWidth = {strokeWidth} >
        
        <rect
          width={2*radius}
          height={radius} 
          fill={fillColor} 
        />
      </g>
    </Draggable>
