nv.addGraph(function() {  
    var chart = nv.models.discreteBarChart()
        .x(function(d) { return d.x })
        .y(function(d) { return d.y })
    
    d3.select('#chart svg')
        .datum(chartData)
        .transition().duration(500)
        .call(chart);

    nv.utils.windowResize(function() { d3.select('#chart svg').call(chart) });

    return chart;
});
