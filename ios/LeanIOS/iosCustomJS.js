// TradePulse — Native feel + iOS 26 black screen fix + Guru Leagues promo

(function() {

  // ── 0. SKIP LANDING PAGE (mobile app only) ───────────────────────────
  // Always skip the marketing landing page — go straight to /sign-in
  // unless already authenticated (then go to /social)
  function skipLandingPage() {
    var path = window.location.pathname;
    var isLanding = path === '/' || path === '/home' || path === '';
    if (!isLanding) return;

    // Check for auth token
    var hasAuth = false;
    try {
      for (var i = 0; i < localStorage.length; i++) {
        var key = localStorage.key(i);
        if (key && (key.indexOf('token') !== -1 || key.indexOf('auth') !== -1 || key.indexOf('user') !== -1 || key.indexOf('session') !== -1)) {
          var val = localStorage.getItem(key);
          if (val && val.length > 10) { hasAuth = true; break; }
        }
      }
    } catch(e) {}

    if (hasAuth) {
      window.location.replace('/social');
    } else {
      window.location.replace('/sign-in');
    }
  }

  skipLandingPage();
  window.addEventListener('load', skipLandingPage);

  // ── 1. NATIVE FEEL CSS ──────────────────────────────────────────────
  var style = document.createElement('style');
  style.textContent = [
    '* { -webkit-user-select: none !important; user-select: none !important; }',
    'input, textarea, [contenteditable] { -webkit-user-select: text !important; user-select: text !important; }',
    '* { -webkit-tap-highlight-color: transparent !important; }',
    '* { -webkit-touch-callout: none !important; }',
    'html, body { overscroll-behavior: none; overflow: hidden; height: 100%; }',
    '#root, #app, .app-container, [data-reactroot] { height: 100%; overflow-y: auto; overscroll-behavior: none; -webkit-overflow-scrolling: touch; }',
    'body { cursor: default; }',
    '* { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }'
  ].join('\n');
  document.head.appendChild(style);

  // ── 2. PREVENT CONTEXT MENU ──────────────────────────────────────────
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

  // ── 4. iOS 26 BLACK SCREEN FIX ───────────────────────────────────────
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

  var _pushState = history.pushState;
  var _replaceState = history.replaceState;

  history.pushState = function() {
    _pushState.apply(history, arguments);
    setTimeout(forceRepaint, 100);
    setTimeout(skipLandingPage, 150);
  };

  history.replaceState = function() {
    _replaceState.apply(history, arguments);
    setTimeout(forceRepaint, 100);
    setTimeout(skipLandingPage, 150);
  };

  window.addEventListener('popstate', function() {
    setTimeout(forceRepaint, 100);
    setTimeout(skipLandingPage, 150);
  });

  var count = 0;
  var interval = setInterval(function() {
    forceRepaint();
    count++;
    if (count >= 6) clearInterval(interval);
  }, 500);

  // ── 5. GURU LEAGUES PROMO OVERLAY ────────────────────────────────────
  // Shows ONCE per session — triggered only after a successful sign-in
  // Detected by: user was on /sign-in or /login, then navigated to /social or /
  var PROMO_CONFIG = {
    image: 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/f0d93aec4_ChatGPTImageMay15202603_07_35PM.png',
    enabled: true,
    duration: 6000,
    label: '⚡ Coming Soon'
  };

  var PROMO_SESSION_KEY = 'tp_promo_shown';
  var PROMO_CAME_FROM_AUTH = 'tp_came_from_auth';

  function fetchPromoConfig(callback) {
    try {
      fetch('https://tradepulsepro.net/api/functions/getMobilePromoConfig', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' }
      })
      .then(function(r) { return r.json(); })
      .then(function(data) {
        if (data && data.image) {
          PROMO_CONFIG.image    = data.image;
          PROMO_CONFIG.enabled  = data.enabled !== false;
          PROMO_CONFIG.duration = data.duration || 6000;
          PROMO_CONFIG.label    = data.label || PROMO_CONFIG.label;
        }
        callback();
      })
      .catch(function() { callback(); });
    } catch(e) { callback(); }
  }

  function showPromoOverlay() {
    if (!PROMO_CONFIG.enabled) return;
    if (sessionStorage.getItem(PROMO_SESSION_KEY)) return;
    sessionStorage.setItem(PROMO_SESSION_KEY, '1');

    var overlay = document.createElement('div');
    overlay.id = 'tp-promo-overlay';
    overlay.style.cssText = [
      'position:fixed', 'inset:0', 'z-index:999999',
      'background:#000',
      'display:flex', 'flex-direction:column',
      'align-items:center', 'justify-content:center',
      'transition:opacity 0.6s ease', 'opacity:1'
    ].join(';');

    var bg = document.createElement('div');
    bg.style.cssText = [
      'position:absolute', 'inset:0',
      'background-image:url(' + PROMO_CONFIG.image + ')',
      'background-size:cover',
      'background-position:center top',
      'background-repeat:no-repeat'
    ].join(';');
    overlay.appendChild(bg);

    var gradient = document.createElement('div');
    gradient.style.cssText = [
      'position:absolute', 'bottom:0', 'left:0', 'right:0',
      'height:220px',
      'background:linear-gradient(to top, rgba(0,0,0,0.97) 0%, rgba(0,0,0,0.5) 60%, transparent 100%)'
    ].join(';');
    overlay.appendChild(gradient);

    var bottom = document.createElement('div');
    bottom.style.cssText = [
      'position:absolute', 'bottom:0', 'left:0', 'right:0',
      'padding:0 32px 60px',
      'display:flex', 'flex-direction:column',
      'align-items:center', 'gap:12px'
    ].join(';');

    var lbl = document.createElement('div');
    lbl.textContent = PROMO_CONFIG.label;
    lbl.style.cssText = [
      'color:#F5C842', 'font-size:11px', 'font-weight:700',
      'letter-spacing:3px', 'text-transform:uppercase',
      'font-family:-apple-system,BlinkMacSystemFont,sans-serif',
      'opacity:0.9'
    ].join(';');
    bottom.appendChild(lbl);

    var track = document.createElement('div');
    track.style.cssText = [
      'width:100%', 'max-width:320px', 'height:4px',
      'background:rgba(255,255,255,0.15)',
      'border-radius:100px', 'overflow:hidden'
    ].join(';');

    var fill = document.createElement('div');
    fill.style.cssText = [
      'height:100%', 'width:0%',
      'background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700)',
      'border-radius:100px',
      'box-shadow:0 0 10px rgba(245,200,66,0.5)'
    ].join(';');
    track.appendChild(fill);
    bottom.appendChild(track);

    var countdown = document.createElement('div');
    countdown.style.cssText = [
      'color:rgba(255,255,255,0.4)', 'font-size:11px',
      'font-family:-apple-system,BlinkMacSystemFont,sans-serif',
      'font-weight:500'
    ].join(';');
    countdown.textContent = 'Loading in 6s\u2026';
    bottom.appendChild(countdown);

    overlay.appendChild(bottom);
    document.body.appendChild(overlay);

    var startTime = Date.now();
    var dur = PROMO_CONFIG.duration;

    function animate() {
      var elapsed = Date.now() - startTime;
      var pct = Math.min((elapsed / dur) * 100, 100);
      var remaining = Math.max(Math.ceil((dur - elapsed) / 1000), 0);
      fill.style.width = pct + '%';
      countdown.textContent = remaining > 0 ? ('Loading in ' + remaining + 's\u2026') : 'Loading\u2026';
      if (elapsed < dur) {
        requestAnimationFrame(animate);
      } else {
        overlay.style.opacity = '0';
        setTimeout(function() {
          if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
        }, 650);
      }
    }
    requestAnimationFrame(animate);
  }

  // Track when user is on auth pages
  function checkNavForPromo() {
    var path = window.location.pathname;
    var isAuthPage = path.indexOf('sign-in') !== -1 || path.indexOf('login') !== -1 ||
                     path.indexOf('sign-up') !== -1 || path.indexOf('register') !== -1;
    var isFeed = path === '/social' || path.indexOf('/social') !== -1;

    if (isAuthPage) {
      // Mark that we came from auth
      sessionStorage.setItem(PROMO_CAME_FROM_AUTH, '1');
    }

    if (isFeed && sessionStorage.getItem(PROMO_CAME_FROM_AUTH)) {
      // User just signed in and landed on feed — show promo
      sessionStorage.removeItem(PROMO_CAME_FROM_AUTH);
      fetchPromoConfig(function() {
        setTimeout(showPromoOverlay, 400);
      });
    }
  }

  var origPush2 = history.pushState;
  history.pushState = function() {
    origPush2.apply(history, arguments);
    checkNavForPromo();
  };

  var origReplace2 = history.replaceState;
  history.replaceState = function() {
    origReplace2.apply(history, arguments);
    checkNavForPromo();
  };

  window.addEventListener('popstate', checkNavForPromo);
  window.addEventListener('load', checkNavForPromo);

})();
