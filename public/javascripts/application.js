// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var NavigateObj = {

  docIntercept: function(e) {
    var expr = new RegExp(window.location.pathname + '$');
    $$('nav a').each(function(a) {
      if (expr.match(a.href)) {
        a.nowActive = true;
        a.addClassName('location');
      }
    });
    $$('nav ul').each(function(ul) {
      ul.observe('click', this.ulIntercept.bindAsEventListener(this));
    });
  },

  ulIntercept: function(e) {
      if (e.element().nowActive)
        e.stop();
  } 
}

document.observe('dom:loaded', NavigateObj.docIntercept.bindAsEventListener(NavigateObj));
