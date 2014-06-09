# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
loadChart = ->
  if $('#heatmap_container').length > 0
    url_namespace = $('#heatmap_container').data('prefix')
    $.ajax
      url: "/#{url_namespace}/heatmap"
      dataType: 'json'
      success: (data)->
        $('#heatmap_container').highcharts
          chart:
            type: 'heatmap'
            marginTop: 10
            marginBottom: 40
            style:
              fontFamily: "tahoma, arial, verdana, sans-serif, 'Lucida Sans', sans-serif"
              fontSize: '10px'
          title:
            text: null
          xAxis:
            type: 'category'
            tickLength: 0
            lineWidth: 0
            labels:
              step: data.step
            offset: 100
          yAxis:
            categories: data.days
            lineWidth: 0
            title: null
            gridLineWidth: 0
            offset: 0
          colorAxis:
            min: 0,
            minColor: '#FFFFFF',
            maxColor: Highcharts.getOptions().colors[6]
          legend:
            enabled: false
          tooltip:
            headerFormat: ''
            formatter: ()->
              if this.point.value
                "<b>#{this.point.value} игр(ы)</b> на #{this.point.day} #{this.point.human_name}"
              else
                "<b>Нет игр</b> на #{this.point.day} #{this.point.human_name}"
            hideDelay: true
            distance: 20
            followPointer: true
          series: [{
            data: data.data,
            nullColor: '#fff',
            borderColor: 'black',
            borderWidth: 0.1,
            allowPointSelect: true,
            cursor: 'pointer',
            states:
              hover:
                color: '#eee'
              select:
                color: '#e11012'
            point:
              events:
                select: (e) ->
                  lis = ""
                  for g in this.games
                    lis += "<li>#{g.beginning_at} <a href='#{g.url}'>#{g.title}</a></li>"
                  link = "<p><a href='/games/new?date=#{this._full_date}' target='_blank'>Назначить игру</a></p>"
                  html = "<h5>#{this.day} #{this.human_name}</h5><ul class='list-unstyled'>#{lis}</ul>#{link}"
                  $('#day-info').html(html)
            dataLabels: {
              enabled: true,
              color: '#000',
              style: {
                textShadow: 'none'
                fontSize: '0px'
                fontWeight: 'normal'
              }
            }
          }]


$ ->
  loadChart()
$(document).on 'page:load', ->
  loadChart()
