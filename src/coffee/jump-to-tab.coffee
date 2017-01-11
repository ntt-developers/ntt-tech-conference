$('a[jump-to-tab]').on 'click', ->
  tab = $(this).attr('jump-to-tab')
  $('#' + tab).click()
  return
