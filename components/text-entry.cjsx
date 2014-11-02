# @cjsx React.DOM
React = require 'react'
Draggable = require '../lib/draggable'

TextEntryTool = React.createClass
  displayName: 'TextEntryTool'

  render: ->

    style =
      top: "#{@props.top}"
      left: "#{@props.left}"

    <div className="text-entry" style={style}>
      <div className="left">
        <div className="input_field state text">
          <a href="#" className="yellow button ok">ok</a>
          <a href="#" className="yellowbutton error">!</a>
          <input 
            type="text" 
            placeholder="Date" 
            className="" 
            role="textbox" 
          />
        </div>
      </div>
      <div className="right">
        <a href="#" className="back">Back</a>
        <a href="#" className="skip">Skip</a>
        <a href="#" className="step">4/9</a>
        <a href="#" className="white button finish">Next Record</a>
      </div>
    </div>

module.exports = TextEntryTool