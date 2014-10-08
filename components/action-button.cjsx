# @cjsx React.DOM

React = require 'react'

ActionButton = React.createClass
  displayName: "ActionButton"

  handleSubmit: (e) ->
    console.log 'ACTION'
    e.preventDefault() # prevent browser's default submit action
    @props.onActionSubmit()

  render: ->
    if @props.loading
      <form onSubmit={@handleSubmit}>
        <input type="submit" className="action-button button" value="LOADING..." disabled />
      </form>

    else
      <form onSubmit={@handleSubmit}>
        <input type="submit" className="action-button button" value="NEXT" />
      </form>

module.exports = ActionButton