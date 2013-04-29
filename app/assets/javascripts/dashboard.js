Date.prototype.getFullMonth = function () {
  switch(this.getMonth()){
    case 0: return 'Gennaio';
    case 1: return 'Febbraio';
    case 2: return 'Marzo';
    case 3: return 'Aprile';
    case 4: return 'Maggio';
    case 5: return 'Giugno';
    case 6: return 'Luglio';
    case 7: return 'Agosto';
    case 8: return 'Settembre';
    case 9: return 'Ottobre';
    case 10: return 'Novembre';
    case 11: return 'Dicembre';
  }
}


  function index_from_date(date) {
    var now = new Date()
    if (date.getTime() > now.getTime()) {
      return (date.getFullYear() - now.getFullYear()) * 12 - now.getMonth() + date.getMonth();
    } else {
      return -1 * (now.getFullYear() - date.getFullYear()) * 12 - now.getMonth() + date.getMonth();
    }
  }

  var date_from_index = function(index) {
    var d = new Date();
    d.setMonth(d.getMonth()+parseInt(index));
    return new Date(d);
  }

  var new_month = function(type){
    var $from = (type == 1) ? $('#timeline .t-month:last-child') : $('#timeline .t-month:first-child');
    var $c = $from.clone();
    $c.attr('data-index', parseInt($c.attr('data-index')) + parseInt(type));
    var d = date_from_index($c.attr('data-index'));
    $('.year', $c).html(d.getFullYear());
    $('.month', $c).html(d.getFullMonth());
    $('.payments', $c).html('<ul/>').load('month/' + $c.attr('data-index') + '/payments', function(){
      window.tellMe.init_everything(this);
    });
    if (type == 1) {
      return $c.insertAfter($from)
    } else {
      $c.insertBefore($from);
      $("#timeline").stop(true, true).scrollTop($("#timeline").scrollTop() + $c.height());
      return $c;
    }
  }

  var go_to_month = function(index){
    var $m = $("#timeline .t-month[data-index=" + index + "]");
    var $from = (index > 0) ? $('#timeline .t-month:last-child') : $('#timeline .t-month:first-child');
    var from_index = parseInt($from.attr('data-index'));
    if ($m.length <= 0) {
      for (var i = 0; i < Math.abs(index - from_index); i++) {
        if (index > 0) {
          $m = new_month(1);
        } else {
          $m = new_month(-1);
        }
      }
      if ($m.next().length <= 0) {
        new_month(1);
      }
    }
    move_timeline($m, 200 * Math.abs(index - from_index) + 1);
  }

  var move_timeline = function(position, speed, callback) {
    if ($("#timeline").is(':animated')) return;
    $("#timeline").stop(true, true).scrollTo(position, {duration: speed, onAfter: function() {
      var $that = $(this);
      var $active = $(".t-month.active", $that);
      $.each($(".t-month", $that), function(index, value) {
        var $this = $(this);
        if ($this.position().top >= -60) {
          var d = date_from_index($this.attr('data-index'));
          var $cmonth = $('#change_month');
          $('.select .value', $cmonth).attr("data-index", d.getMonth()).html(d.getFullMonth());
          $('input', $cmonth).val(d.getFullYear());
          if ($active.length <= 0 || $active.attr('data-index') != $this.attr('data-index')) {
            $active.removeClass('active');
            $this.addClass('active');
          }
          return false;
        }
      });
      if (typeof callback == 'function') {
        callback.call(this);
      }
    }});
  }



$(function() {

  $("#timeline").mousewheel(function(event, delta) {
    var t = null;
    if (delta > 0) {
      var first = $('#timeline .t-month:first-child');
      if (first.position().top >= -40) {
        first = new_month(-1);
      }
    } else {
      var last = $('#timeline .t-month:last-child');
      if (last.position().top <= $(this).height() - 40) {
        new_month(+1);
      }
    }
    //delta = wheelDistance(event.originalEvent);
    //move_timeline($(this).scrollTop() - (delta * 100), 10);
    move_timeline($(this).scrollTop() - (delta * 50), 10);
    return false;
  });

  var wheelDistance = function(evt){
    if (!evt) evt = event;
    var w=evt.wheelDelta, d=evt.detail;
    console.log(w);
    if (d){
      if (w) return w/d/40*d>0?1:-1; // Opera
      else return -d/3;              // Firefox;         TODO: do not /3 for OS X
    } else return w/120;             // IE/Safari/Chrome TODO: /3 for Chrome OS X
  };



  $(document).on('click.ml', '#change_month button', function(event){
    var $this = $(this);
    var $form = $this.closest('#change_month');
    var today = new Date();
    var month = today.getMonth();
    var year = today.getFullYear();
    if ($this.is('.change')) {
      year = parseInt($('input', $form).val());
      month = parseInt($('.select .value', $form).attr('data-index'));
    }
    go_to_month(index_from_date(new Date(year, month, 1)));
    event.preventDefault();
    return false;
  }).on('click.ml', '#change_month a', function(event) {
    var $this = $(this);
    $('.select .value', $this.closest('#change_month')).html($this.html()).attr('data-index', $this.attr('data-index'));
    event.preventDefault();
  }).on('click.ml', '#clients .clients > li', function(event) {
    var $this = $(this);
    $('.clients > li', $this.closest('#clients')).removeClass('active');
    $this.addClass('active');
    $(document).scrollTo($this, 200, {offset:-60});
  });

  move_timeline($('.t-month[data-index=0]'), 500);



});
