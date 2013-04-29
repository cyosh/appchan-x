PSAHiding =
  init: ->
    return unless Conf['Announcement Hiding']

    entry =
      type: 'header'
      el: $.el 'a',
        textContent: 'Show announcement'
        className: 'show-announcement'
        href: 'javascript:;'
      order: 50
      open: ->
        if $.id('globalMessage')?.hidden
          return true
        false
    $.event 'AddMenuEntry', entry

    $.on entry.el, 'click', PSAHiding.toggle 
    $.addClass doc, 'hide-announcement'

    $.on d, '4chanXInitFinished', @setup

  setup: ->
    $.off d, '4chanXInitFinished', PSAHiding.setup

    unless psa = $.id 'globalMessage'
      return

    PSAHiding.btn = btn = $.el 'a',
      innerHTML: '<span>[&nbsp;-&nbsp;]</span>'
      title:     'Hide announcement.'
      className: 'hide-announcement' 
      href: 'javascript:;'
      textContent: '[ - ]'
    $.on btn, 'click', PSAHiding.toggle

    $.get 'hiddenPSAs', [], (item) ->
      PSAHiding.sync item['hiddenPSAs']

  toggle: (e) ->
    text = PSAHiding.trim $.id 'globalMessage'
    $.get 'hiddenPSAs', [], ({hiddenPSAs}) -> 
      if hide
        hiddenPSAs.push text
        hiddenPSAs = hiddenPSAs[-5..] 
      else
        $.event 'CloseMenu' 
        i = hiddenPSAs.indexOf text
        hiddenPSAs.splice i, 1
      PSAHiding.sync hiddenPSAs
      $.set 'hiddenPSAs', hiddenPSAs

  sync: (hiddenPSAs) ->
    psa = $.id 'globalMessage'
    psa.hidden = PSAHiding.btn.hidden = if hiddenPSAs.contains PSAHiding.trim(psa)
      true 
    else
      false
    if (hr = psa.nextElementSibling) and hr.nodeName is 'HR'
      hr.hidden = psa.hidden
  trim: (psa) ->
    psa.textContent.replace(/\W+/g, '').toLowerCase()
