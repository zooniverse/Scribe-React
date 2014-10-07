# @cjsx React.DOM

React = require 'react'

LoadingIndicator = React.createClass
  displayName: 'LoadingIndicator'

  render: ->
    @transferPropsTo <span className="loading-indicator">
      Loading
      <span>•</span>
      <span>•</span>
      <span>•</span>
    </span>

module.exports = LoadingIndicator