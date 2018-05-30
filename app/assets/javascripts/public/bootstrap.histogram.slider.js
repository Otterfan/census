/*
    Adapted from https://www.jqueryscript.net/chart-graph/Histogram-Slider-Plugin-jQuery.html
*/
; (function ($, window, document, undefined) {
    var pluginName = "histogramSlider",
        dataKey = "plugin_" + pluginName;

    var updateHistogram = function (selectedRange, sliderMin, rangePerBin, histogramName, sliderName, options) {
        var leftValue = selectedRange[0],
            rightValue = selectedRange[1];

        $("#" + sliderName + "-value").html(leftValue + " - " + rightValue);

        if (options.earliestFieldId){
            $("#" + options.earliestFieldId).val(leftValue).change();
        }

        if (options.latestFieldId){
            $("#" + options.latestFieldId).val(rightValue).change();
        }

        // set opacity per bin based on the slider values
        $("#" + histogramName + " .in-range").each(function (index, bin) {
            var binRange = getBinRange(rangePerBin, index, sliderMin);

            if (binRange[1] <= rightValue) {
                // Set opacity based on left (min) slider
                if (leftValue > binRange[1]) {
                    setOpacity(bin, 0);
                } else if (leftValue < binRange[0]) {
                    setOpacity(bin, 1);
                } else {
                    //setOpacity(bin, 1);
                    setOpacity(bin, 1 - (leftValue - binRange[0]) / rangePerBin);
                }
            } else if (binRange[0] > leftValue) {
                // Set opacity based on right (max) slider value
                if (rightValue > binRange[1]) {
                    setOpacity(bin, 1);
                } else if (rightValue < binRange[0]) {
                    setOpacity(bin, 0);
                } else {
                    //setOpacity(bin, 1);
                    setOpacity(bin, (rightValue - binRange[0]) / rangePerBin);
                }
            }
        });
    };

    var getBinRange = function(rangePerBin, index, sliderMin) {
        var min = sliderMin + (rangePerBin * index),
            max = sliderMin + rangePerBin * (index + 1) - 1;

        return [min, max];
    };

    var setOpacity = function(bin, val) {
        $(bin).css("opacity", val);
    };

    var convertToHeight = function (v) {
        return parseInt(5 * v + 1);
    };

    var calculateHeightRatio = function(bins, histogramHeight) {
        var updatedHistogramHeight = histogramHeight;
        var maxValue = Math.max.apply(null, bins);
        var height = convertToHeight(maxValue);

        //console.log("updatedHistogramHeight: " + updatedHistogramHeight);
        //console.log("maxValue: " + maxValue);
        //console.log("height: " + height);

        if (height > updatedHistogramHeight) {
            return updatedHistogramHeight / height;
        }

        return 1;
    };

    var Plugin = function (element, options) {
        this.element = element;

        this.options = {
            sliderRange: [0, 1000000], // Min and Max slider values
            optimalRange: [0, 0], // Optimal range to select within
            selectedRange: [0, 0], // Min and Max slider values selected
            height: 200,
            numberOfBins: 40,
            showTooltips: false,
            showSelectedRange: false
        };

        this.init(options);
    };

    Plugin.prototype = {
        init: function (options) {
            $.extend(this.options, options);

            var self = this,
                dataItems = self.options.data.items,
                bins = new Array(this.options.numberOfBins).fill(0),
                range = self.options.sliderRange[1] - self.options.sliderRange[0] + 1, // add 1 to range to be inclusive
                rangePerBin = (range / this.options.numberOfBins);

            //console.log("slider lower: " + self.options.sliderRange[0]);
            //console.log("slider higher: " + self.options.sliderRange[1]);
            //console.log("range: " + range);
            //console.log("number of bins: " + bins.length);
            //console.log("rangePerBin: " + rangePerBin);
            //console.log("there are " + dataItems.length + " data points");

            for (i = 0; i < dataItems.length; i++) {
                var index = parseInt((dataItems[i].value - self.options.sliderRange[0]) / rangePerBin),
                    increment = 1;

                //console.log("looking at data point #" + i +  "; val: " + dataItems[i].value + "; put into bin index: " + index);

                if (dataItems[i].count) {
                    // Handle grouped data structure
                    increment = parseInt(dataItems[i].count);
                }

                bins[index] += increment;
            }

            //console.log(bins);

            var histogramName = self.element.attr('id') + "-histogram",
                sliderName = self.element.attr('id') + "-slider";

            var wrapHtml = "<div id='" + histogramName + "' style='height:" + self.options.height + "px; overflow: hidden;'></div>" +
                "<div id='" + sliderName + "'></div>";

            self.element.html(wrapHtml);

            var heightRatio = calculateHeightRatio(bins, self.options.height),
                widthPerBin = 100 / this.options.numberOfBins,
                maxValue = Math.max.apply(null, bins);

            //console.log("found max value from bins: " + maxValue);

            for (var i = 0; i < bins.length; i++) {
                //console.log("this is bin #" + i);
                var binRange = getBinRange(rangePerBin, i, this.options.sliderRange[0]),
                    inRangeClass = "bin-color-selected",
                    outRangeClass = "bin-color";

                //console.log("  my binRange: " + binRange + "; smallest range:" + this.options.sliderRange[0] + "; rangePerBin: " + rangePerBin);

                if (self.options.optimalRange[0] <= binRange[0] && binRange[0] <= self.options.optimalRange[1]) {
                    inRangeClass = "bin-color-optimal-selected";
                    outRangeClass = "bin-color-optimal";
                }

                var toolTipHtml = self.options.showTooltips ? "<span class='tooltiptext'>" + binRange[0] + " - " + binRange[1] + "</br>count: " + bins[i] + "</span>" : "";

                //var scaledValue = parseInt(bins[i] * heightRatio),
                var scaledValue = parseInt(bins[i] * ((self.options.height - 10) / maxValue)),
                    //height = convertToHeight(scaledValue),
                    height = scaledValue + 10,
                    inRangeOffset = parseInt(self.options.height - height),
                    outRangeOffset = -parseInt(self.options.height - height * 2);

                //console.log("  bin elements: " + bins[i]);
                //console.log("  heightRatio: " + heightRatio);
                //console.log("  scaledValue: " + scaledValue);
                //console.log("  height: " + height);

                var binHtml = "<div class='tooltip-slider' style='float:left!important;width:" + widthPerBin + "%;'>" +
                    toolTipHtml +
                    "<div class='bin in-range " + inRangeClass + "' style='height:" + height + "px;bottom:-" + inRangeOffset + "px;position: relative;'></div>" +
                    "<div class='bin out-of-range " + outRangeClass + "' style='height:" + height + "px;bottom:" + outRangeOffset + "px;position: relative;'></div>" +
                    "</div>";

                $("#" + histogramName).append(binHtml);
            }

            $("#" + sliderName).slider({
                range: true,
                min: self.options.sliderRange[0],
                max: self.options.sliderRange[1],
                value: self.options.selectedRange,
                tooltip: "hide"
            }).on('slide', function(event){
                updateHistogram(event.value, self.options.sliderRange[0], rangePerBin, histogramName, sliderName, self.options);
            }).on('slideStop', function(event){
                updateHistogram(event.value, self.options.sliderRange[0], rangePerBin, histogramName, sliderName, self.options);
            });

            if (self.options.showSelectedRange){
                $("#" + sliderName).after("<p id='" + sliderName + "-value' class='selected-range'></p>");
            }

            if (self.options.earliestFieldId){
                $("#" + self.options.earliestFieldId).val(self.options.sliderRange[0]);
            }

            if (self.options.latestFieldId){
                $("#" + self.options.latestFieldId).val(self.options.sliderRange[1]);
            }

            updateHistogram(self.options.selectedRange, self.options.sliderRange[0], rangePerBin, histogramName, sliderName, self.options);
        }
    };

    $.fn[pluginName] = function (options) {
        var plugin = this.data(dataKey);

        if (plugin instanceof Plugin) {
            if (typeof options !== 'undefined') {
                plugin.init(options);
            }
        } else {
            plugin = new Plugin(this, options);
            this.data(dataKey, plugin);
        }

        return plugin;
    };

}(jQuery, window, document));
