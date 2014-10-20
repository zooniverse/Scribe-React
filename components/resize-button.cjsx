# @cjsx React.DOM

React = require 'react'

module.exports = React.createClass
  displayName: 'ResizeButton'

  handleMouseDown: (e) ->
    console.log 'RESIZING MARK ', @props
    @props.resizeMark e

  render: ->

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
  
    <g 
      transform = {@props.transform} 
      className = "clickable drawing-tool-resize-button" 
      stroke = {strokeColor} 
      strokeWidth = {strokeWidth} >
      
      <circle 
        onClick={console.log "CLICK~!!!!"}
        r={radius} 
        fill={fillColor} 
      />
      <path d={cross} transform="rotate(90)" />
    </g>
