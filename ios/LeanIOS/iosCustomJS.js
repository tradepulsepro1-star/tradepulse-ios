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

    // Dark backdrop
    var backdrop = document.createElement('div');
    backdrop.style.cssText = 'position:fixed;inset:0;z-index:999998;background:rgba(0,0,0,0.75);opacity:0;transition:opacity 0.3s ease';
    document.body.appendChild(backdrop);

    // Full-screen popup
    var popup = document.createElement('div');
    popup.style.cssText = [
      'position:fixed',
      'inset:0',
      'z-index:999999',
      'background:#0A0E1A',
      'opacity:0',
      'transition:opacity 0.35s ease'
    ].join(';');

    // Full-screen image
    var img = document.createElement('div');
    img.style.cssText = [
      'position:absolute',
      'inset:0',
      'background-image:url(' + PROMO_CONFIG.image + ')',
      'background-size:cover',
      'background-position:center center',
      'background-repeat:no-repeat'
    ].join(';');
    popup.appendChild(img);

    // Bottom gradient
    var grad = document.createElement('div');
    grad.style.cssText = 'position:absolute;bottom:0;left:0;right:0;height:180px;background:linear-gradient(to top,rgba(10,14,26,0.95) 0%,rgba(10,14,26,0.4) 60%,transparent 100%)';
    popup.appendChild(grad);

    // Label at bottom
    var label = document.createElement('div');
    label.textContent = PROMO_CONFIG.label;
    label.style.cssText = 'position:absolute;bottom:90px;left:0;right:0;text-align:center;color:#F5C842;font-size:15px;font-weight:600;font-family:-apple-system,sans-serif;letter-spacing:0.3px';
    popup.appendChild(label);

    function dismiss() {
      popup.style.opacity = '0';
      setTimeout(function() {
        if (popup.parentNode) popup.parentNode.removeChild(popup);
        if (backdrop.parentNode) backdrop.parentNode.removeChild(backdrop);
      }, 350);
    }

    backdrop.addEventListener('click', dismiss);

    // X button — top right
    var xBtn = document.createElement('button');
    xBtn.textContent = '✕';
    xBtn.style.cssText = [
      'position:absolute',
      'top:52px',
      'right:20px',
      'z-index:10',
      'width:36px',
      'height:36px',
      'border-radius:50%',
      'background:rgba(0,0,0,0.6)',
      'border:1.5px solid rgba(255,255,255,0.25)',
      'color:#fff',
      'font-size:15px',
      'cursor:pointer',
      '-webkit-appearance:none',
      'display:flex',
      'align-items:center',
      'justify-content:center',
      'line-height:1',
      'font-family:-apple-system,sans-serif'
    ].join(';');
    xBtn.addEventListener('click', dismiss);
    popup.appendChild(xBtn);

    document.body.appendChild(popup);

    // Animate in
    setTimeout(function() {
      backdrop.style.opacity = '1';
      popup.style.opacity = '1';
    }, 50);
  }

  function checkForPromo() {
    var path = window.location.pathname;
    var isFeed = path === '/social' || path.indexOf('/social') === 0;
    if (!isFeed) return;
    if (sessionStorage.getItem(PROMO_KEY)) return;
    fetchPromoConfig(showPromoOverlay);
  }

  // Watch for SPA route changes via polling
  var lastPath = window.location.pathname;
  setInterval(function() {
    var currentPath = window.location.pathname;
    if (currentPath !== lastPath) {
      lastPath = currentPath;
      checkForPromo();
    }
  }, 300);

  // Also check on initial load (e.g. app opens directly to /social)
  setTimeout(checkForPromo, 1000);

})();
