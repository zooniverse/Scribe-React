React            = require 'react'
$                = require '../lib/jquery-2.1.0.min.js'

LoadingIndicator = require './loading-indicator'

marks = []


MarkingSurface = React.createClass
  displayName: "MarkingSurface"

  handleClick: (e) ->
    @addMark( e.nativeEvent.pageX, e.nativeEvent.pageY )
    # console.log "SCROLL TOP:", @getDOMNode().scrollTop
    
  addMark: (x,y) ->
    marks.push 
      x: x
      y: y
      wid: 100
      hei: 100
    @forceUpdate()

  render: ->
    if @props.loading
      <div className="marking-surface">
        <LoadingIndicator />
      </div> 
    else
      <div className="marking-surface">
        <img className="subject-image" src={@props.url} onClick={@handleClick} />
        <MarksList mark_list={marks} />
      </div>


MarksList = React.createClass
  displayName: "MarksList"

  render: ->
    <div className="marks-list">
      {@props.mark_list.map((mark) ->
        <Mark xpos={mark.x} ypos={mark.y} wid={mark.wid} hei={mark.hei} />
      )}
    </div>


Mark = React.createClass
  displayName: "Mark"
  render: ->
    <div className="mark" style={{top: @props.ypos-@props.hei/2, left: @props.xpos-@props.wid/2, width: @props.wid, height: @props.hei }}>
    </div>

module.exports = MarkingSurface