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
//= require jquery.browser
//= require jquery.splitter
//= require jquery.remotipart
//= require bootstrap-transition
//= require bootstrap-dropdown
//= require bootstrap-tooltip
//= require bootstrap-tooltip-extension
//= require bootstrap-popover
//= require bootstrap-button
//= require bootstrap-fileupload
//= require fartscroll
//= require perfect-scrollbar-0.4.3.with-mousewheel.min
//= require_tree .

var entries_selected = false;
var notif_activated = false;

// Lock to avoid multiple clicks on the new/edit subscription button
var new_subscription_lock = false;
var edit_subscription_lock = false;

function auto_resize() {
  $("#content").css("width", ($(window).width() - 340) + "px");
  $("#content").css("height", ($(window).height() - 80) + "px");
}

function loadSpin() {
  $("#loading").css("visibility", "visible");
}

function feedLoader() {
  // loading icon
  $("#content").html('<div id="loading-feed">' +
        '<i class="icon-spinner icon-spin icon-2x"></i>' +
        '&nbsp; <span>Loading feed...</span>' +
      '</div>');
  $('#loading-feed').css('margin-top', ($('#content').height()/2 - 10) + 'px');
}

function loadInsideSpin(elmt) {
  $(elmt).children().removeClass('icon-ok');
  $(elmt).children().addClass('icon-spinner icon-spin');
}

function unloadInsideSpin(elmt) {
  $(elmt).children().removeClass('icon-spinner icon-spin');
  $(elmt).children().addClass('icon-ok');
}

$(function() {
  auto_resize();

  $(window).resize(auto_resize);

  // change the active item of the navigation menu
  $("ul.nav li a").click(function() {
    $(".nav li").removeClass("active");
    $(this).parent().addClass("active");
  });

  // auto resize feeds list
  $("#streams_list").css("max-height", ($(window).height() - 310) + "px");
  $("#streams_list").perfectScrollbar({
    wheelSpeed: 30
  });

  $("#panel_splitter").splitter();

  $.star_item = function() {
    $('#entries-form').attr('action', '/feed_entries_actions/star_items');
    $('#entries-form').attr('method', 'put');
    $('#entries-form').submit();
  };

  $.unstar_item = function() {
    $('#entries-form').attr('action', '/feed_entries_actions/unstar_items');
    $('#entries-form').attr('method', 'put');
    $('#entries-form').submit();
  };

  $.mark_as_read = function() {
    $('#entries-form').attr('action', '/feed_entries_actions/mark_as_read');
    $('#entries-form').attr('method', 'put');
    $('#entries-form').submit();
  };

  $.mark_as_unread = function() {
    $('#entries-form').attr('action', '/feed_entries_actions/mark_as_unread');
    $('#entries-form').attr('method', 'put');
    $('#entries-form').submit();
  };

  $.remove_item = function() {
    $('#entries-form').attr('action', '/feed_entries_actions/remove_items');
    $('#entries-form').attr('method', 'delete');
    $('#entries-form').submit();
  };

  $.restore_item = function() {
    $('#entries-form').attr('action', '/feed_entries_actions/restore_items');
    $('#entries-form').attr('method', 'put');
    $('#entries-form').submit();
  };

  $.toggle_entries_toolbar = function(checkall) {
    // update toolbar buttons
    if (!entries_selected) {
      // toggle special toolbar
      $('#entries-buttons').fadeOut('fast', function() {
        $('#selected-entries-buttons').fadeIn('fast');
      });

      // check all checkbox
      if (checkall)
        $('#entries input[type="checkbox"]').attr('checked', true);

      // update flag
      entries_selected = true;
    } else {
      // toggle normal toolbar
      $('#selected-entries-buttons').fadeOut('fast', function() {
        $('#entries-buttons').fadeIn('fast');
      });

      // uncheck all checkbox
      if (checkall)
        $('#entries input[type="checkbox"]').attr('checked', false);

      // update flag
      entries_selected = false;
    }
  };

  function close_notif() {
    $('#notification').slideUp('fast');
    notif_activated = false;
  }

  $.notify = function(mess, type) {
    // effect for displaying the new notification
    // /!\ synchronous/asynchronous stuff !
    var isReady = false;
    if (notif_activated)
      isReady = $('#notification').slideUp('fast');
    else
      isReady = true;

    // create close button
    /*var closeButton = '<a href="#" id="close-button">\
      <i class="icon-remove close"></i></a>';*/
    var closeButton =
      '<button id="close-button" class="close">&times;</button>';

    $.when(isReady).then(function() {
      // handle type of error
      if (type === 'error') {
        $('#notification').css('background-color', '#FF8080');
        $('#notification').css('border-color', 'rgb(255, 15, 15)');
        icon = '<i class="icon-remove-sign icon-large"></i> ';
      } else if (type === 'warning') {
        $('#notification').css('background-color', '#FFBD59');
        $('#notification').css('border-color', 'rgb(254, 119, 54)');
        icon = '<i class="icon-warning-sign icon-large"></i> ';
      } else if (type === 'success') {
        icon = '<i class="icon-ok icon-large"></i> ';
        $('#notification').css('background-color', '#8DE182');
        $('#notification').css('border-color', 'rgb(131, 205, 82)');
        icon = '<i class="icon-ok-sign icon-large"></i> ';
      } else {
        $('#notification').css('background-color', '#E0E0E0');
        $('#notification').css('border-color', 'rgb(204, 204, 204)');
        icon = '<i class="icon-info-sign icon-large"></i> ';
      }

      $('#notification').css("left",
        (($(window).width()/2) - ($('#notification').width()/2)) + "px");
      $('#notification').slideDown('slow');
      $('#notification').html(icon + "&nbsp;" + mess + closeButton);

      // add lisetener to the close button
      $('#close-button').click(close_notif);
      /*$('#close-button').mouseover(function() {
        $('#close-button i').removeClass('icon-remove')
                            .addClass('icon-remove-circle');
      });

      $('#close-button').mouseout(function() {
        $('#close-button i').removeClass('icon-remove-circle')
                            .addClass('icon-remove');
      });*/

      // automatically close the notification after 5 sec
      setTimeout(close_notif, 5000);
    });

    notif_activated = true;
  };

  // Easter eggs
  $(window).on('hashchange', function() {
    var hash = location.hash.replace('#', '');
    if (hash === 'fart') {
      fartscroll(20);
      alert('prout');
    }
  });
});
