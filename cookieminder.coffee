class CookieImageProcessor
  constructor: (@src,@rects) ->
    @image = new Image
    @image.src = @src
    @image.onload = => @onLoaded()

  onLoaded: ->
    @canvas = document.createElement "CANVAS"
    @canvas.width = @image.width
    @canvas.height = @image.height
    @ctx = @canvas.getContext '2d'
    @ctx.drawImage @image, 0, 0
    @imageData = @ctx.getImageData(0,0,@canvas.width,@canvas.height)

    @process()

  process: ->
    zones = ( new CookieZone(@, rect) for rect in @rects )
    
    zone.process() for zone in zones

    @ctx.putImageData @imageData, 0, 0


    document.body.appendChild @canvas


class CookieZone
  constructor: (@processor,@rect) ->

  process: ->
    @data = @processor.imageData.data

    @avgColor =
      r: 0
      g: 0
      b: 0

    width = @processor.imageData.width

    for x in [@rect.x...@rect.x+@rect.w]
      for y in [@rect.y...@rect.y+@rect.h]
        i = (x + y * width) * 4
        @avgColor.r += @data[i+0]
        @avgColor.g += @data[i+1]
        @avgColor.b += @data[i+2]

    totalPixels = @rect.w * @rect.h
    @avgColor.r /= totalPixels
    @avgColor.g /= totalPixels
    @avgColor.b /= totalPixels

    console.log @avgColor


new CookieImageProcessor 'test/cookies.jpg', [
  {x:133, y:210, w:83, h:183}
  {x:287, y:210, w:83, h:183}
  {x:419, y:210, w:83, h:183}
  {x:529, y:210, w:83, h:183}
]