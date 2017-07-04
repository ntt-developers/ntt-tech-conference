$('a[jump-to-tab]').on 'click', ->
  speed = 400
  tab = $(this).attr('jump-to-tab')
  $('#' + tab).click()
  target = $($(this).attr('target'))
  $('body,html').animate({ scrollTop: target.offset().top },
                         speed,
                         'swing')
  return
