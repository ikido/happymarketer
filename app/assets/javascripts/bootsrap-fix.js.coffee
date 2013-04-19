@fixThumbnails = ->
  
    $('.row-fluid .thumbnails').each ->
                
        thumbnails = $(@).children()
        if thumbnails.first().offset()
          previousOffsetLeft = thumbnails.first().offset().left
        else
          previousOffsetLeft = 0
                                
        thumbnails.removeClass('first-in-row')
        thumbnails.first().addClass('first-in-row')
        
        thumbnails.each ->
            thumbnail = $(@)
            if thumbnail.offset()
              offsetLeft = thumbnail.offset().left
            else
              offsetLeft = 0
              
            if (offsetLeft < previousOffsetLeft)
              # mark as first
              thumbnail.addClass('first-in-row')

            previousOffsetLeft = offsetLeft
