initTokenInput = ->
  input = $("#tags")
  input.select2
    tokenSeparators: [' ']
    placeholder: 'Один или больше тэгов, например (D&D4ed Fallout)'
    tags: true
    createSearchChoice: (term, data)->
      existing_term = data.filter (d)-> d.text == term
      if existing_term.length == 0
        {id: "#{term}_new", text: term}
    query: (query)->
      _data = results: []
      $.ajax
        url: '/tags'
        dataType: 'json'
        data:
          q: query.term
        success: (data)->
          for d in data
            _data.results.push {id: d.id, text: d.text }
          query.callback(_data)

  input.select2 'data', input.data('pre')

initPicker = ->
  $('.calendar').on 'click', (e)->
    e.preventDefault()
    e.stopPropagation()
    #HACK fix it!!!
    _picker = $(this).parent().parent().find('.dtpicker')
    _picker.datetimepicker
      lang: 'ru'
      format: 'd-m-Y H:i'
    _picker.datetimepicker('show')

initCocoonPicker = ->
  $('.events').on 'cocoon:after-insert', ->
    initPicker()

$ ->
  initTokenInput()
  initPicker()
  initCocoonPicker()

$(document).on 'page:load', ->
  initTokenInput()
  initPicker()

