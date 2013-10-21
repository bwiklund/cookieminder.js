class CookieImageProcessor
  constructor: (src) ->
    @image = new Image
    @image.src = src
    @image.onload = => @onLoaded()

  onLoaded: ->
    @canvas = document.createElement "CANVAS"
    @canvas.width = @image.width
    @canvas.height = @image.height
    @ctx = @canvas.getContext '2d'
    @ctx.drawImage @image, 0, 0
    document.body.appendChild @canvas

new CookieImageProcessor 'test/cookies.jpg'