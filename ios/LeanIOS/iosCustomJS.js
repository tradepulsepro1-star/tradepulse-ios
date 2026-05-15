// TradePulse — Native feel + iOS 26 black screen fix

(function() {

  // ── 1. NATIVE FEEL CSS ──────────────────────────────────────────────
  var style = document.createElement('style');
  style.textContent = [
    // Disable text selection everywhere
    '* { -webkit-user-select: none !important; user-select: none !important; }',
    // Re-enable selection only in input fields
    'input, textarea, [contenteditable] { -webkit-user-select: text !important; user-select: text !important; }',
    // Kill tap highlight flash (blue/grey flash on tap)
    '* { -webkit-tap-highlight-color: transparent !important; }',
    // Kill callout menu (copy/paste/share popup on long press)
    '* { -webkit-touch-callout: none !important; }',
    // Disable bounce/rubber-band scroll on body
    'html, body { overscroll-behavior: none; overflow: hidden; height: 100%; }',
    '#root, #app { height: 100%; overflow-y: auto; overscroll-behavior: none; -webkit-overflow-scrolling: touch; }',
    // Prevent cursor from showing on non-input elements
    'body { cursor: default; }',
    // Smooth font rendering — native quality
    '* { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }'
  ].join('\n');
  document.head.appendChild(style);

  // ── 2. PREVENT CONTEXT MENU (long press popup) ──────────────────────
  document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
    return false;
  }, true);

  // ── 3. PREVENT SELECTION VIA TOUCH ──────────────────────────────────
  document.addEventListener('selectstart', function(e) {
    if (!e.target.matches('input, textarea, [contenteditable]')) {
      e.preventDefault();
    }
  }, true);

  // ── 4. iOS 26 BLACK SCREEN FIX (WKWebView repaint) ──────────────────
  function forceRepaint() {
    document.body.style.display = 'none';
    void document.body.offsetHeight;
    document.body.style.display = '';
  }

  if (document.readyState === 'complete') {
    forceRepaint();
  } else {
    window.addEventListener('load', forceRepaint);
  }

  // SPA navigation (React router)
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

  // Fallback repaint every 500ms for first 3 seconds
  var count = 0;
  var interval = setInterval(function() {
    forceRepaint();
    count++;
    if (count >= 6) clearInterval(interval);
  }, 500);

})();
