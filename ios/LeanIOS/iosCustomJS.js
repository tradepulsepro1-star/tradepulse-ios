// TradePulse iOS 26 black screen fix
// Forces WebView to repaint after page load
(function() {
  function forceRepaint() {
    document.body.style.display = 'none';
    // Force layout pass
    void document.body.offsetHeight;
    document.body.style.display = '';
  }

  // On initial load
  if (document.readyState === 'complete') {
    forceRepaint();
  } else {
    window.addEventListener('load', forceRepaint);
  }

  // On SPA navigation (React router changes)
  var _pushState = history.pushState;
  var _replaceState = history.replaceState;

  history.pushState = function() {
    _pushState.apply(history, arguments);
    setTimeout(forceRepaint, 100);
  };

  history.replaceState = function() {
    _replaceState.apply(history, arguments);
    setTimeout(forceRepaint, 100);
  };

  window.addEventListener('popstate', function() {
    setTimeout(forceRepaint, 100);
  });

  // Fallback: force repaint every 500ms for first 3 seconds
  var count = 0;
  var interval = setInterval(function() {
    forceRepaint();
    count++;
    if (count >= 6) clearInterval(interval);
  }, 500);
})();
