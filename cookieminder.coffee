class CookieImageProcessor
  constructor: (@src,@rects) ->
    @image = new Image
    @image.src = @src
    @image.onload = => @onLoaded()

  onLoaded: ->
    @startTime = new Date()
    @canvas = document.createElement "CANVAS"
    @canvas.width = @image.width
    @canvas.height = @image.height
    @ctx = @canvas.getContext '2d'
    @ctx.drawImage @image, 0, 0
    @imageData = @ctx.getImageData(0,0,@canvas.width,@canvas.height)

    @process()

  process: ->
    console.log "analyzing cookies..."
    zones = ( new CookieZone(@, rect) for rect in @rects )
    
    zone.process() for zone in zones

    @ctx.putImageData @imageData, 0, 0

    @endTime = new Date()

    console.log "processed #{zones.length} dispensers in #{@endTime - @startTime}ms"

    document.body.appendChild @canvas


class CookieZone
  constructor: (@processor,@rect) ->

  process: ->
    @data = @processor.imageData.data

    width = @processor.imageData.width

    # if a pixel is saturated enough, we assume it has cookies.
    # simple but effective given the setting and lighting of the cookies
    pixelsOfCookies = 0

    for x in [@rect.x...@rect.x+@rect.w]
      for y in [@rect.y...@rect.y+@rect.h]
        i = (x + y * width) * 4
        color = new Color @data[i+0], @data[i+1], @data[i+2]
        hsv = color.hslData()
        pixelsOfCookies += 1 if hsv[1] > 0.1


    totalPixels = @rect.w * @rect.h
    cookieStatus = pixelsOfCookies / totalPixels
    cookieStatus -= 0.05
    cookieStatus *= 100/81.4
    console.log (100*cookieStatus).toFixed(2) + "% " + @rect.contents


new CookieImageProcessor 'test/cookies.jpg', [
  {x:133, y:210, w:83, h:183, contents: 'Chex'}
  {x:287, y:210, w:83, h:183, contents: 'Cheerios'}
  {x:419, y:210, w:83, h:183, contents: 'Nilla Wafers'}
  {x:529, y:210, w:83, h:183, contents: 'Pretzels'}
]