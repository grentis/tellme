// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require bootstrap
//= require bootstrap-modal
//= require bootstrap-modalmanager
//= require bootstrap-datepicker
//= require locales/bootstrap-datepicker.it
//= require select2/select2


(function($) {
  window.TellMe = function() {
    this.init_everything($(document));

    this.currencyFieldKeyDown = $.proxy(this.currencyFieldKeyDown, this);
    this.currencyFieldKeyUp = $.proxy(this.currencyFieldKeyUp, this);
    this.currencyFieldFocusOut = $.proxy(this.currencyFieldFocusOut, this);
  };

  TellMe.prototype = {
    init_everything: function(context) {
      this.init_datepicker(context);
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
                            format: 'MM yyyy',
                            minViewMode: 1,
                            startView: 1
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
          if (r.text === '') { return o.value.length; }
          return o.value.lastIndexOf(r.text);
        } else {
          return o.selectionStart;
        }
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
    }
  };

  window.tellMe = new TellMe();
  $(document)
    .delegate('textarea.note', 'focus', tellMe.expandField)
    .delegate('textarea.note', 'blur', tellMe.collapseField)
    .delegate('input.currency', 'keydown', tellMe.currencyFieldKeyDown)
    .delegate('input.currency', 'keyup', tellMe.currencyFieldKeyUp)
    .delegate('input.currency', 'focusout', tellMe.currencyFieldFocusOut);
})(jQuery);