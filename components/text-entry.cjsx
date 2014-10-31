# @cjsx React.DOM
React = require 'react'
Draggable = require '../lib/draggable'

TextEntry = React.createClass
  displayName: 'TextEntryTool'

  render: ->
    <div className="text-entry">
      <p>This is a text entry</p>
    </div> 

module.exports = TextEntryTool