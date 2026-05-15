// TradePulse — Native feel + iOS 26 black screen fix + Guru Leagues promo

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
    '#root, #app, .app-container, [data-reactroot] { height: 100%; overflow-y: auto; overscroll-behavior: none; -webkit-overflow-scrolling: touch; }',
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

  // ── 5. GURU LEAGUES PROMO OVERLAY (mobile only, once per session) ────
  var PROMO_IMAGE = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/455911563_ChatGPTImageMay15202609_04_21AM.png';
  var PROMO_DURATION = 6000; // 6 seconds
  var PROMO_KEY = 'tp_guru_leagues_promo_shown';

  function showGuruLeaguesPromo() {
    // Only show once per session
    if (sessionStorage.getItem(PROMO_KEY)) return;
    sessionStorage.setItem(PROMO_KEY, '1');

    // Build overlay
    var overlay = document.createElement('div');
    overlay.id = 'tp-promo-overlay';
    overlay.style.cssText = [
      'position: fixed',
      'inset: 0',
      'z-index: 999999',
      'background: #000',
      'display: flex',
      'flex-direction: column',
      'align-items: center',
      'justify-content: center',
      'transition: opacity 0.6s ease',
      'opacity: 1'
    ].join(';');

    // Full-screen background image
    var bg = document.createElement('div');
    bg.style.cssText = [
      'position: absolute',
      'inset: 0',
      'background-image: url(' + PROMO_IMAGE + ')',
      'background-size: cover',
      'background-position: center top',
      'background-repeat: no-repeat'
    ].join(';');
    overlay.appendChild(bg);

    // Bottom gradient for readability
    var gradient = document.createElement('div');
    gradient.style.cssText = [
      'position: absolute',
      'bottom: 0',
      'left: 0',
      'right: 0',
      'height: 200px',
      'background: linear-gradient(to top, rgba(0,0,0,0.95) 0%, rgba(0,0,0,0.5) 60%, transparent 100%)'
    ].join(';');
    overlay.appendChild(gradient);

    // Bottom content container
    var bottom = document.createElement('div');
    bottom.style.cssText = [
      'position: absolute',
      'bottom: 0',
      'left: 0',
      'right: 0',
      'padding: 0 32px 56px',
      'display: flex',
      'flex-direction: column',
      'align-items: center',
      'gap: 10px'
    ].join(';');

    // "Coming Soon" label
    var label = document.createElement('div');
    label.textContent = '⚡ Coming Soon';
    label.style.cssText = [
      'color: #F5C842',
      'font-size: 11px',
      'font-weight: 700',
      'letter-spacing: 3px',
      'text-transform: uppercase',
      'font-family: -apple-system, BlinkMacSystemFont, sans-serif',
      'opacity: 0.9'
    ].join(';');
    bottom.appendChild(label);

    // Progress bar track
    var track = document.createElement('div');
    track.style.cssText = [
      'width: 100%',
      'max-width: 320px',
      'height: 4px',
      'background: rgba(255,255,255,0.15)',
      'border-radius: 100px',
      'overflow: hidden'
    ].join(';');

    // Progress bar fill
    var fill = document.createElement('div');
    fill.style.cssText = [
      'height: 100%',
      'width: 0%',
      'background: linear-gradient(90deg, #B8860B, #F5C842, #FFD700)',
      'border-radius: 100px',
      'box-shadow: 0 0 10px rgba(245,200,66,0.5)',
      'transition: width 0.1s linear'
    ].join(';');
    track.appendChild(fill);
    bottom.appendChild(track);

    // Countdown text
    var countdown = document.createElement('div');
    countdown.style.cssText = [
      'color: rgba(255,255,255,0.4)',
      'font-size: 11px',
      'font-family: -apple-system, BlinkMacSystemFont, sans-serif',
      'font-weight: 500'
    ].join(';');
    countdown.textContent = 'Loading in 6s\u2026';
    bottom.appendChild(countdown);

    overlay.appendChild(bottom);
    document.body.appendChild(overlay);

    // Animate progress bar
    var startTime = Date.now();
    var rafId;

    function animate() {
      var elapsed = Date.now() - startTime;
      var pct = Math.min((elapsed / PROMO_DURATION) * 100, 100);
      var remaining = Math.max(Math.ceil((PROMO_DURATION - elapsed) / 1000), 0);

      fill.style.width = pct + '%';
      countdown.textContent = remaining > 0 ? ('Loading in ' + remaining + 's\u2026') : 'Loading\u2026';

      if (elapsed < PROMO_DURATION) {
        rafId = requestAnimationFrame(animate);
      } else {
        // Fade out and remove
        overlay.style.opacity = '0';
        setTimeout(function() {
          if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
        }, 650);
      }
    }

    rafId = requestAnimationFrame(animate);
  }

  // Trigger promo when user lands on the feed after sign-in
  // Watch for URL changes — show promo when hitting /social or / after auth
  function checkForFeedAndShowPromo() {
    var path = window.location.pathname + window.location.hash;
    var isFeed = path === '/' || path.indexOf('/social') !== -1 || path.indexOf('#/social') !== -1 || path === '/#/';
    if (isFeed) {
      // Small delay to let auth state settle
      setTimeout(showGuruLeaguesPromo, 300);
    }
  }

  // Hook into SPA navigation
  var origPush = history.pushState;
  history.pushState = function() {
    origPush.apply(history, arguments);
    checkForFeedAndShowPromo();
  };

  var origReplace = history.replaceState;
  history.replaceState = function() {
    origReplace.apply(history, arguments);
    checkForFeedAndShowPromo();
  };

  window.addEventListener('popstate', checkForFeedAndShowPromo);

  // Also check on initial load
  window.addEventListener('load', checkForFeedAndShowPromo);

})();
