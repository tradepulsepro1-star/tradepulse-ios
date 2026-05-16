// TradePulse — Native feel + iOS 26 black screen fix + Splash + Guru Leagues promo

(function() {

  // ── INSTANT AUTH REDIRECT (runs before React mounts) ─────────────────
  (function() {
    var path = window.location.pathname;
    var isLanding = path === '/' || path === '' || path === '/home';
    if (!isLanding) return;
    // If splash already shown this session and user is logged in → skip landing page
    if (!sessionStorage.getItem('tp_splash_shown')) return;
    try {
      for (var i = 0; i < localStorage.length; i++) {
        var key = localStorage.key(i);
        if (key && (key.indexOf('token') !== -1 || key.indexOf('auth') !== -1 ||
                    key.indexOf('user') !== -1 || key.indexOf('session') !== -1)) {
          var val = localStorage.getItem(key);
          if (val && val.length > 10) {
            window.location.replace('/social');
            return;
          }
        }
      }
    } catch(e) {}
  })();

  // ── NATIVE FEEL CSS ───────────────────────────────────────────────────
  var style = document.createElement('style');
  style.textContent = [
    // Disable text selection everywhere except inputs
    '* { -webkit-user-select: none !important; user-select: none !important; }',
    'input, textarea, [contenteditable] { -webkit-user-select: text !important; user-select: text !important; }',
    // No tap highlight flash
    '* { -webkit-tap-highlight-color: transparent !important; }',
    // No callout popups on long press
    '* { -webkit-touch-callout: none !important; }',
    // Smooth fonts
    '* { -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }',
    // No bounce scroll on body — allow scroll on content containers
    'body { overscroll-behavior-y: none; }',
  ].join('\n');
  document.head.appendChild(style);

  // ── PREVENT CONTEXT MENU ──────────────────────────────────────────────
  document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
    return false;
  }, true);

  // ── PREVENT SELECTION VIA TOUCH ──────────────────────────────────────
  document.addEventListener('selectstart', function(e) {
    if (!e.target.matches('input, textarea, [contenteditable]')) {
      e.preventDefault();
    }
  }, true);

  // ── iOS 26 BLACK SCREEN FIX ───────────────────────────────────────────
  // Only runs ONCE on initial load — does NOT hook pushState (breaks SPA nav)
  function forceRepaint() {
    try {
      document.body.style.display = 'none';
      void document.body.offsetHeight;
      document.body.style.display = '';
    } catch(e) {}
  }

  if (document.readyState === 'complete') {
    setTimeout(forceRepaint, 50);
  } else {
    window.addEventListener('load', function() {
      setTimeout(forceRepaint, 50);
    });
  }

  // ── APP OPEN SPLASH ───────────────────────────────────────────────────
  var SPLASH_IMAGE = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
  var SPLASH_DURATION = 7000;
  var SPLASH_KEY = 'tp_splash_shown';

  function hasAuthToken() {
    try {
      for (var i = 0; i < localStorage.length; i++) {
        var key = localStorage.key(i);
        if (key && (key.indexOf('token') !== -1 || key.indexOf('auth') !== -1 ||
                    key.indexOf('user') !== -1 || key.indexOf('session') !== -1)) {
          var val = localStorage.getItem(key);
          if (val && val.length > 10) return true;
        }
      }
    } catch(e) {}
    return false;
  }

  function showSplash() {
    var path = window.location.pathname;
    var isLanding = path === '/' || path === '' || path === '/home';
    if (!isLanding) return;

    // Splash already shown this session
    if (sessionStorage.getItem(SPLASH_KEY)) {
      if (hasAuthToken()) {
        window.location.replace('/social');
      } else {
        window.location.replace('/sign-in');
      }
      return;
    }

    sessionStorage.setItem(SPLASH_KEY, '1');

    var overlay = document.createElement('div');
    overlay.id = 'tp-splash-overlay';
    overlay.style.cssText = 'position:fixed;inset:0;z-index:9999999;background:#000;display:flex;align-items:center;justify-content:center;opacity:1;transition:opacity 0.7s ease';

    var bg = document.createElement('div');
    bg.style.cssText = 'position:absolute;inset:0;background-image:url(' + SPLASH_IMAGE + ');background-size:cover;background-position:center center;background-repeat:no-repeat';
    overlay.appendChild(bg);

    var track = document.createElement('div');
    track.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
    var fill = document.createElement('div');
    fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px;box-shadow:0 0 12px rgba(245,200,66,0.6)';
    track.appendChild(fill);
    overlay.appendChild(track);

    document.body.appendChild(overlay);

    var startTime = Date.now();
    function animate() {
      var elapsed = Date.now() - startTime;
      var pct = Math.min((elapsed / SPLASH_DURATION) * 100, 100);
      fill.style.width = pct + '%';
      if (elapsed < SPLASH_DURATION) {
        requestAnimationFrame(animate);
      } else {
        overlay.style.opacity = '0';
        setTimeout(function() {
          if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
          if (hasAuthToken()) {
            window.location.replace('/social');
          } else {
            window.location.replace('/sign-in');
          }
        }, 720);
      }
    }
    requestAnimationFrame(animate);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', showSplash);
  } else {
    showSplash();
  }

  // ── GURU LEAGUES PROMO OVERLAY ────────────────────────────────────────
  var PROMO_CONFIG = {
    image: 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/f0d93aec4_ChatGPTImageMay15202603_07_35PM.png',
    enabled: true,
    duration: 6000,
    label: '⚡ Coming Soon'
  };
  var PROMO_KEY = 'tp_promo_shown';
  var PROMO_AUTH_KEY = 'tp_came_from_auth';

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
    if (sessionStorage.getItem(PROMO_KEY)) return;
    sessionStorage.setItem(PROMO_KEY, '1');

    var overlay = document.createElement('div');
    overlay.id = 'tp-promo-overlay';
    overlay.style.cssText = 'position:fixed;inset:0;z-index:999999;background:#000;display:flex;flex-direction:column;align-items:center;justify-content:center;opacity:1;transition:opacity 0.6s ease';

    var bg = document.createElement('div');
    bg.style.cssText = 'position:absolute;inset:0;background-image:url(' + PROMO_CONFIG.image + ');background-size:cover;background-position:center top;background-repeat:no-repeat';
    overlay.appendChild(bg);

    var gradient = document.createElement('div');
    gradient.style.cssText = 'position:absolute;bottom:0;left:0;right:0;height:220px;background:linear-gradient(to top,rgba(0,0,0,0.97) 0%,rgba(0,0,0,0.5) 60%,transparent 100%)';
    overlay.appendChild(gradient);

    var bottom = document.createElement('div');
    bottom.style.cssText = 'position:absolute;bottom:0;left:0;right:0;padding:0 32px 60px;display:flex;flex-direction:column;align-items:center;gap:16px';

    var label = document.createElement('div');
    label.textContent = PROMO_CONFIG.label;
    label.style.cssText = 'color:rgba(255,255,255,0.7);font-size:13px;font-family:-apple-system,sans-serif;letter-spacing:0.5px;text-align:center';
    bottom.appendChild(label);

    var track = document.createElement('div');
    track.style.cssText = 'width:100%;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
    var fill = document.createElement('div');
    fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px;box-shadow:0 0 12px rgba(245,200,66,0.6)';
    track.appendChild(fill);
    bottom.appendChild(track);
    overlay.appendChild(bottom);

    document.body.appendChild(overlay);

    var dur = PROMO_CONFIG.duration;
    var startTime = Date.now();
    function animate() {
      var elapsed = Date.now() - startTime;
      var pct = Math.min((elapsed / dur) * 100, 100);
      fill.style.width = pct + '%';
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

  function checkForPromo() {
    var path = window.location.pathname;
    var isFeed = path === '/social' || path.indexOf('/social') === 0;
    if (!isFeed) return;
    if (!sessionStorage.getItem(PROMO_AUTH_KEY)) return;
    if (sessionStorage.getItem(PROMO_KEY)) return;
    fetchPromoConfig(showPromoOverlay);
  }

  // Mark that user came through auth (sign-in page)
  function trackAuthNavigation() {
    var path = window.location.pathname;
    if (path.indexOf('sign-in') !== -1 || path.indexOf('login') !== -1 || path.indexOf('auth') !== -1) {
      sessionStorage.setItem(PROMO_AUTH_KEY, '1');
    }
  }

  // Watch for SPA route changes (without touching pushState — use polling instead)
  var lastPath = window.location.pathname;
  setInterval(function() {
    var currentPath = window.location.pathname;
    if (currentPath !== lastPath) {
      lastPath = currentPath;
      trackAuthNavigation();
      checkForPromo();
    }
  }, 300);

  // Also check on initial load
  trackAuthNavigation();
  setTimeout(checkForPromo, 800);

})();
