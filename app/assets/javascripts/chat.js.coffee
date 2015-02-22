$ ->
  socket = new WebSocket "ws://#{window.location.host}/chat#{window.location.pathname}"

  socket.onmessage = (event) ->
    if event.data.length
      $("#output").append "#{event.data}<br>"

  $("body").on "submit", "form.chat", (event) ->
    event.preventDefault()
    $input = $(this).find("input")
    socket.send "#{window.location.pathname.substring(1)},#{$input.val()}"
    $input.val(null)