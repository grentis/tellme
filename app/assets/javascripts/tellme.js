(function($) {

  $.fn.wait = function(time, type) {
    time = time || 1000;
    type = type || "fx";
    return this.queue(type, function() {
        var self = this;
        setTimeout(function() {
            $(self).dequeue();
        }, time);
    });
  };

  window.TellMe = function() {
    var that = this;
    $(document).ready(function() {
      setTimeout(function(){
        that.init_everything($(document));
      }, 100);
    });

    this.currencyFieldKeyDown = $.proxy(this.currencyFieldKeyDown, this);
    this.currencyFieldKeyUp = $.proxy(this.currencyFieldKeyUp, this);
    this.currencyFieldFocusOut = $.proxy(this.currencyFieldFocusOut, this);
  };

  TellMe.prototype = {
    init_everything: function(context) {
      this.init_datepicker(context);
      this.init_clickover(context);
      this.init_filterClientSelect(context);
    },
    init_filterClientSelect: function(context) {
      $('#filter_client_id', context).select2({
        allowClear: true,
        formatResult: function(state) {
          return window.tellMe.clientSelect2Format(state);
        },
        escapeMarkup: function(m) { return m; }
      }).on('change', function(e){
        var $this = $(e.currentTarget);
        $this.closest('form').trigger('submit');
        $('.filtered').removeClass('filtered');
        if (e.val) {
          $('.payment.media[data-client!='+e.val+']').addClass('filtered');
          var $l = $this.parent().find('.filter-details');
          var h = $l.attr('href').split("/");
          h[h.length - 1] = e.val;
          $l.removeClass('none').attr('href', h.join("/"));
        } else {
          $this.parent().find('.filter-details').addClass('none');
          $('.filtered').removeClass('filtered');
        }
      });
    },
    init_clickover: function(context) {
      $('.has-popup', context).clickover({
        html: true
      });
    },
    init_datepicker: function(context) {
      var opts = {
        autoclose: true,
        language: 'it'
      }
      $('input.date', context).each(function(){
        var $this = $(this);
        var type = $this.data('date-type') || 'day';
        switch(type){
          case 'day': $this.datepicker(
                        $.extend(opts, {
                          format: 'dd.mm.yyyy'
                        })
                      ); return;
          case 'month': $this.datepicker(
                          $.extend(opts, {
                            format: 'dd MM yyyy'
                          })
                        ); return;
        }
      });
    },
    expandField: function(e) {
      var $this = $(this);
      var eh = $this.data('expanded-height') || '60px';
      $this.stop().animate({
        height: eh
      });
    },
    expandClientSection: function(e) {
      var $this = $(this);
      if ($this.hasClass('expand')){
        $this.closest('.client').find('.exp').show();
        $this.removeClass('expand').addClass('collapse');
      } else {
        $this.closest('.client').find('.exp').hide();
        $this.removeClass('collapse').addClass('expand');
      }
      return false;
    },
    collapseField: function(e) {
      var $this = $(this);
      var eh = $this.data('collapsed-height') || '30px';
      $this.stop().animate({
        height: eh
      });
    },
    currencyFieldParse: function(field) {
      var decimalSeparator = ",";
      var str = field.val();
      if (str.length == 0) return;
      var p = parseFloat(str.replace(/,/,".")).toFixed(2);
      if (isNaN(p)) p = "";
      field.val(p.replace(/\./,decimalSeparator));
    },
    currencyFieldKeyDown: function(e) {
      var getPos = function(o){
        if (o.createTextRange) {
          var r = document.selection.createRange().duplicate();
          r.moveEnd('character', o.value.length);
          if (r.text === '') return o.value.length;
          return o.value.lastIndexOf(r.text);
        } else
          return o.selectionStart;
      };
      var $$this = e.currentTarget;
      var $this = $($$this);
      var code = (e.keyCode ? e.keyCode : e.which);
      var typed = String.fromCharCode(code);
      var functional = false;
      var parse = false;
      var str = $this.val();
      var allowNegative = true;
      var decimalSeparator = ",";

      // check Backspace, Tab, Enter, Delete, and left/right arrows
      if ($.inArray(code, [8,9,13,46,37,39]) != -1) functional = true;

      if((e.ctrlKey || e.metaKey) && $.inArray(code, [97, 120, 99, 122, /* opera */ 65, 88, 67, 90]) != -1) functional = true;
      // allow or deny Ctrl+V (paste), Shift+Ins
      if(((e.ctrlKey || e.metaKey) && $.inArray(code, [118, /* opera */86]) != -1) || (e.shiftKey && code == 45)) functional = parse = true;
      // virgola
      if (code == 188 && str.indexOf(decimalSeparator) == -1) functional = true;

      if (allowNegative && (code == 189 || code == 109) && getPos($$this) == 0) functional = true; // dash as well

      // allow key numbers, 0 to 9
      if((code >= 48 && code <= 57) || (code >= 96 && code <= 105)) {
        functional = true;
        if (getPos($$this) == 0 && str.indexOf("-") != -1) functional = false;
        if (str.split(decimalSeparator).length > 1 && getPos($$this) > str.indexOf(decimalSeparator)) {
          if (str.split(decimalSeparator)[1].length > 1) functional = false;
        }
      }

      if (!functional) {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }
      if (parse) $this.data('currency-parse', true);
    },
    currencyFieldKeyUp: function(e){
      var $this = $(e.currentTarget);
      if ($this.data("currency-parse")){
        this.currencyFieldParse($this);
        $(this).data("currency-parse", null)
      }
    },
    currencyFieldFocusOut: function(e){
      var $this = $(e.currentTarget);
      this.currencyFieldParse($this);
    },
    clientSelect2Format: function(state){
      if (!state.id) return state.text + "&nbsp;";
      var $originalOption = $(state.element);
      var p = "<span>"+state.text+"</span>";
      p += ($originalOption.data('address') ? ("<span style='display:block;font-size:10px;line-height:16px'>" + $originalOption.data('address') + "</span>") : '');
      p += ($originalOption.data('note') ? ("<span style='display:block;font-size:10px;line-height:16px;padding-bottom:5px'>" + $originalOption.data('note') + "</span>") : '');
      return p;
    }
  };

  window.tellMe = new TellMe();
  $(document)
    .delegate('textarea.expand', 'focus', tellMe.expandField)
    .delegate('textarea.expand', 'blur', tellMe.collapseField)
    .delegate('input.currency', 'keydown', tellMe.currencyFieldKeyDown)
    .delegate('input.currency', 'keyup', tellMe.currencyFieldKeyUp)
    .delegate('input.currency', 'focusout', tellMe.currencyFieldFocusOut)
    .on('nested:fieldAdded', function(event){
      tellMe.init_everything(event.field);
    })
    .delegate('span.expand a', 'click', tellMe.expandClientSection)
    .ajaxComplete(function(event, request, settings) {
      msg = request.getResponseHeader("X-Message")
      alert_type = 'alert-info'
      if (request.getResponseHeader("X-Message-Type").indexOf("error") != -1)
        alert_type = 'alert-error'
      if (msg) {
        $("#flash_hook").replaceWith("<div id='flash_hook'><p>&nbsp;</p><div class='row-fluid'><div class='span10 offset2'><div class='alert " + alert_type + "'><button type='button' class='close' data-dismiss='alert'>&times;</button>" + msg + "</div></div></div></div>").wait(800).hide();
      } else {
        $("#flash_hook").replaceWith("<div id='flash_hook'></div>");
      }
      setTimeout(function(){
        $("#flash_hook").replaceWith("<div id='flash_hook'></div>");
      }, 3000);
    });

  setTimeout(function(){
    $("#flash_hook").replaceWith("<div id='flash_hook'></div>");
  }, 3000);
})(jQuery);