$(document).ready(function() {

  $.jstree._themes = '/assets/jsTree/themes/';

  function reprocessWidths() {
    var width = $('#fonds-tree-wrapper').width();
    $('#fonds-tree-wrapper').css('height', 'auto');
    $('#main').css('left', width + 'px');
    $('#main-form-controls').css('left', width + 1 + 'px');
  }

  function cleanClassInfo() {
    $('tr.info').each(function() {
      $(this).removeClass('info');
    });
  }

  function disable_units_link(units) {
    if (units === 0) {
      $("#tab-units").parent().addClass('disabled');
      $("#tab-units").attr('href', '#');
    } else {
      $("#tab-units").parent().removeClass('disabled');
    }
  }

/* Upgrade 2.0.0 inizio */
/*
  var suffix = (location.pathname.split("/").length > 3) ? 'units' : 'fond',
  initial_node_id = location.pathname.split("/").slice(2, 3).pop(),
  initial_unit_id = location.pathname.split("/").slice(4, 5).pop(),
  tree_width = parseInt(localStorage.getItem('tree_width')) || 280;

  nella versione 2.0.0 location.pathname possono essere:
  XXXXX/fonds/NN
  XXXXX/fonds/NN/units/UU
  XXXXX/groups/GG/fonds/NN
  XXXXX/groups/GG/fonds/NN/units/UU
  quindi si deve cambiare il modo con cui ricavare suffix, initial_node_id e initial_unit_id
*/
  var parts;
  var suffix;
  var group_context_path;
  var i;
  var group_id;
  var initial_node_id;
  var initial_unit_id;
  
  suffix = "fond";
  group_context_path = "";
  group_id = "";
  initial_node_id = 0;
  initial_unit_id = 0;

  parts = location.pathname.split("/");
  for (i = 0; i < parts.length; i++)
  {
    switch (parts[i])
    {
      case "groups":
        if (i < parts.length - 1) group_id = parts[i+1];
        break;
      case "fonds":
        if (i < parts.length - 1) initial_node_id = parts[i+1];
        break;
      case "units":
        if (i < parts.length - 1) initial_unit_id = parts[i+1];
        suffix = "units";
        break;
    }
  }
	if (group_id != "") group_context_path = "/groups/" + group_id;
  var tree_width = parseInt(localStorage.getItem('tree_width')) || 280;
/* Upgrade 2.0.0 fine */

  $('#fonds-tree-wrapper').css('width', tree_width);
  reprocessWidths();

  $("#fonds-tree").jstree({
    core: {
      initially_open: ["node-" + initial_node_id],
      strings: {
        loading: "Caricamento..."
      }
    },
    plugins: ["themes", "ui", "json_data"],
    themes: {
      theme: "apple",
      dots: false,
      icons: true
    },
    ui: {
      initially_select: ["#node-" + initial_node_id],
      "select_limit": 1
    },
    json_data: {
      ajax: {
        dataType: "json",
/* Upgrade 2.0.0 inizio */
//        url: "/fonds/" + initial_node_id + "/tree.json"
/* Upgrade 2.0.0 fine */
        url: group_context_path + "/fonds/" + initial_node_id + "/tree.json"
      }
    }
  }).bind("loaded.jstree", function() {
/* Upgrade 2.0.0 inizio */
    var isIE;
    isIE = BrowserDetectIsIE();
/* Upgrade 2.0.0 fine */
    $(this).find('a.changeable').each(function() {
      $(this).addClass('load-' + suffix);
      if (suffix === 'units') {
        $(this).attr("href", $(this).attr("href") + '/' + suffix);
      }

      var units_count = $(this).parent("li").data('units');
      if (units_count !== 0) {
        $(this).append(' <em>(' + units_count + ')</em>');
      }
      
/* Upgrade 2.0.0 inizio */
      if (isIE) $(this).on("click", function() { window.location.href = $(this).attr("href"); return false; } );
/* Upgrade 2.0.0 fine */
    });

/* Upgrade 2.0.0 inizio */
    var units;
/* Upgrade 2.0.0 fine */
    units = $("#node-" + initial_node_id).data('units');
    disable_units_link(units);
  });

  /* Scroll to selected unit on page load */
  if (suffix === 'units' && initial_unit_id !== undefined) {
    $("#units-tree-wrapper").scrollTo($("#unit-" + initial_unit_id).parents('tr'), 800, {
      axis: 'y'
    });
  }

  /* Highlight current unit and scroll to it */
  $("#units-tree").on("click", ".load-unit", function() {
    cleanClassInfo();
    $(this).parents('tr').addClass('info');
    $("#units-tree-wrapper").scrollTo($(this).parents('tr'), 800, {
      axis: 'y'
    });
  });

  /* Update tabs links */
  $("#fonds-tree").on("click", ".load-fond", function() {
    href = $(this).attr('href');
    $('#tab-fonds').attr('href', href);
    $('#tab-units').attr('href', href + '/units');
  });

  $("#fonds-tree").on("click", ".load-units", function() {
    href = $(this).attr('href');
    tokens = href.split("/");
    tokens.pop();
    $('#tab-fonds').attr('href', tokens.join('/'));
    $('#tab-units').attr('href', href);
  });

  /* Disable tab-units if there is nothing */
  $("#fonds-tree").on("click", ".changeable", function() {
    units = $(this).parent().data('units');
    disable_units_link(units);
  });

  /* Load description of the first unit in the list */
/* Upgrade 2.0.0 inizio */
// sembra sia inutile
/*
  $('#units-tree').on('pjax:end', function() {
    $that = $('#units-tree').find('a.load-unit').first();
    if ($that.length !== 0) {
      $.pjax({
        // Upgrade 2.0.0 inizio per gestione gruppi 
        // url: '/fonds/' + $that.data('fond-id') + '/units/' + $that.data('id'),
        url: group_context_path + '/fonds/' + $that.data('fond-id') + '/units/' + $that.data('id'),
        // Upgrade 2.0.0 fine 
        container: '#units-wrapper'
      });
      $("#units-tree-wrapper").scrollTo($("#unit-" + $that.data('id')).parents('tr'), 800, {
        axis: 'y'
      });
    } else {
      $("#units-wrapper").html('');
    }
  });
/* Upgrade 2.0.0 fine */

  /* Remember tree size */
  $("#fonds-tree-wrapper").resizable({
    handles: {
      'e': "#handle"
    },
    minWidth: 280,
    maxWidth: 760,
    resize: function() {
      reprocessWidths();
    },
    stop: function(event, ui) {
      localStorage.setItem('tree_width', ui.size.width);
    }
  });

  /* Re-select the tree node when pressing back button */
  /* TODO: fatto parzialmente. C'è da fixare back su units */
  $(window).on('pjax:popstate', function(event) {
    // Debug
    // console.log(event.state);
    fond = location.pathname.split("/").slice(2, 3).pop();
    $("#fonds-tree").jstree("deselect_all");
    $("#fonds-tree").jstree("select_node", "#node-" + fond);

    if (location.pathname.split("/").length > 4) {
      unit = location.pathname.split("/").slice(4, 5).pop();
      cleanClassInfo();
      $('#unit-' + unit).parents('tr').addClass('info');
      $("#units-tree-wrapper").scrollTo($("#unit-" + unit).parents('tr'), 800, {
        axis: 'y'
      });
    }
  });

/* Upgrade 2.0.0 inizio */
  function BrowserDetectIsIE()
  {
    return (BrowserDetectGetIEVersion() > 0);
  }

  function BrowserDetectGetIEVersion()
  {
    var match;
    var iev;

    try
    {
      match = navigator.userAgent.match(/(?:MSIE |Trident\/.*; rv:)(\d+)/);
      iev = match ? parseInt(match[1]) : 0;
    }
    catch (e)
    {
      iev = 0;
    }
    return iev;
  }
/* Upgrade 2.0.0 fine */
  
});
