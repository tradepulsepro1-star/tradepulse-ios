// TradePulse iOS — Native feel + Splash + Guru Leagues promo
// Injected at DocumentStart — body may not exist yet, use DOMContentLoaded for DOM ops

(function() {

  // ── NATIVE FEEL CSS (safe at DocumentStart via <head>) ────────────────
  function applyNativeCSS() {
    var style = document.createElement('style');
    style.textContent = [
      '* { -webkit-user-select: none !important; user-select: none !important; }',
      'input, textarea, [contenteditable] { -webkit-user-select: text !important; user-select: text !important; }',
      '* { -webkit-tap-highlight-color: transparent !important; }',
      '* { -webkit-touch-callout: none !important; }',
      '* { -webkit-font-smoothing: antialiased; }',
      'body { overscroll-behavior-y: none; }'
    ].join('\n');
    document.head.appendChild(style);

    // Suppress Reader Mode
    var noReader = document.createElement('meta');
    noReader.name = 'apple-mobile-web-app-capable';
    noReader.content = 'yes';
    document.head.appendChild(noReader);
  }

  // head is available at DocumentStart
  if (document.head) {
    applyNativeCSS();
  } else {
    document.addEventListener('DOMContentLoaded', applyNativeCSS);
  }

  // ── PREVENT CONTEXT MENU ─────────────────────────────────────────────
  document.addEventListener('contextmenu', function(e) { e.preventDefault(); return false; }, true);

  // ── PREVENT TEXT SELECTION ───────────────────────────────────────────
  document.addEventListener('selectstart', function(e) {
    if (!e.target.matches('input, textarea, [contenteditable]')) e.preventDefault();
  }, true);

  // ── HELPERS ──────────────────────────────────────────────────────────
  var SPLASH_KEY = 'tp_splash_shown';
  var PROMO_KEY  = 'tp_promo_shown';

  function hasAuthToken() {
    try {
      for (var i = 0; i < localStorage.length; i++) {
        var k = localStorage.key(i);
        if (k && (k.indexOf('token') !== -1 || k.indexOf('auth') !== -1 ||
                  k.indexOf('user') !== -1 || k.indexOf('session') !== -1)) {
          var v = localStorage.getItem(k);
          if (v && v.length > 10) return true;
        }
      }
    } catch(e) {}
    return false;
  }

  // ── SPLASH SCREEN ─────────────────────────────────────────────────────
  var SPLASH_IMAGE    = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
  var SPLASH_DURATION = 7000;

  function showSplash() {
    sessionStorage.setItem(SPLASH_KEY, '1');

    var overlay = document.createElement('div');
    overlay.style.cssText = 'position:fixed;inset:0;z-index:9999999;background:#000;opacity:1;transition:opacity 0.7s ease';

    var bg = document.createElement('div');
    bg.style.cssText = 'position:absolute;inset:0;background-image:url(' + SPLASH_IMAGE + ');background-size:cover;background-position:center';
    overlay.appendChild(bg);

    var track = document.createElement('div');
    track.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
    var fill = document.createElement('div');
    fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px;transition:none';
    track.appendChild(fill);
    overlay.appendChild(track);
    document.body.appendChild(overlay);

    var start = Date.now();
    function tick() {
      var pct = Math.min(((Date.now() - start) / SPLASH_DURATION) * 100, 100);
      fill.style.width = pct + '%';
      if (pct < 100) {
        requestAnimationFrame(tick);
      } else {
        overlay.style.opacity = '0';
        setTimeout(function() {
          if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
          window.location.replace(hasAuthToken() ? '/social' : '/sign-in');
        }, 720);
      }
    }
    requestAnimationFrame(tick);
  }

  // ── BOOT — waits for body to exist ───────────────────────────────────
  function boot() {
    // Always show splash once per session on cold open
    if (!sessionStorage.getItem(SPLASH_KEY)) {
      showSplash();
      return;
    }
    // Splash already shown — block landing page
    var p = window.location.pathname;
    if (p === '/' || p === '' || p === '/home') {
      window.location.replace(hasAuthToken() ? '/social' : '/sign-in');
    }
  }

  // DOMContentLoaded fires when body is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }

  // ── SPA NAV WATCHER — block landing page on SPA navigation ───────────
  var lastPath = window.location.pathname;
  setInterval(function() {
    var cur = window.location.pathname;
    if (cur !== lastPath) {
      lastPath = cur;
      if (cur === '/' || cur === '' || cur === '/home') {
        window.location.replace(hasAuthToken() ? '/social' : '/sign-in');
        return;
      }
      if (cur === '/social' || cur.indexOf('/social') === 0) {
        setTimeout(fetchAndShowPromo, 600);
      }
    }
  }, 300);

  // ── GURU LEAGUES PROMO POPUP ──────────────────────────────────────────
  var PROMO_FALLBACK = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/f0d93aec4_ChatGPTImageMay15202603_07_35PM.png';

  function showPromoPopup(cfg) {
    if (!cfg.enabled) return;
    if (sessionStorage.getItem(PROMO_KEY)) return;
    sessionStorage.setItem(PROMO_KEY, '1');

    var backdrop = document.createElement('div');
    backdrop.style.cssText = 'position:fixed;inset:0;z-index:999998;background:rgba(0,0,0,0.75);opacity:0;transition:opacity 0.3s ease';
    document.body.appendChild(backdrop);

    var popup = document.createElement('div');
    popup.style.cssText = 'position:fixed;inset:0;z-index:999999;background:#0A0E1A;opacity:0;transition:opacity 0.35s ease';

    var img = document.createElement('div');
    img.style.cssText = 'position:absolute;inset:0;background-image:url(' + cfg.image + ');background-size:cover;background-position:center;background-repeat:no-repeat';
    popup.appendChild(img);

    var grad = document.createElement('div');
    grad.style.cssText = 'position:absolute;bottom:0;left:0;right:0;height:160px;background:linear-gradient(to top,rgba(10,14,26,0.95) 0%,transparent 100%)';
    popup.appendChild(grad);

    var lbl = document.createElement('div');
    lbl.textContent = cfg.label || '⚡ Coming Soon';
    lbl.style.cssText = 'position:absolute;bottom:80px;left:0;right:0;text-align:center;color:#F5C842;font-size:15px;font-weight:600;font-family:-apple-system,sans-serif;letter-spacing:0.3px';
    popup.appendChild(lbl);

    function dismiss() {
      popup.style.opacity = '0';
      backdrop.style.opacity = '0';
      setTimeout(function() {
        if (popup.parentNode) popup.parentNode.removeChild(popup);
        if (backdrop.parentNode) backdrop.parentNode.removeChild(backdrop);
      }, 350);
    }

    backdrop.addEventListener('click', dismiss);

    var xBtn = document.createElement('button');
    xBtn.textContent = '✕';
    xBtn.style.cssText = 'position:absolute;top:52px;right:20px;z-index:10;width:36px;height:36px;border-radius:50%;background:rgba(0,0,0,0.6);border:1.5px solid rgba(255,255,255,0.25);color:#fff;font-size:15px;cursor:pointer;-webkit-appearance:none;line-height:36px;text-align:center;font-family:-apple-system,sans-serif';
    xBtn.addEventListener('click', dismiss);
    popup.appendChild(xBtn);

    document.body.appendChild(popup);
    setTimeout(function() { backdrop.style.opacity = '1'; popup.style.opacity = '1'; }, 50);
  }

  function fetchAndShowPromo() {
    if (sessionStorage.getItem(PROMO_KEY)) return;
    var cfg = { image: PROMO_FALLBACK, enabled: true, label: '⚡ Coming Soon' };
    try {
      fetch('https://tradepulsepro.net/api/functions/getMobilePromoConfig')
        .then(function(r) { return r.json(); })
        .then(function(d) {
          if (d && d.image) { cfg.image = d.image; cfg.enabled = d.enabled !== false; cfg.label = d.label || cfg.label; }
          showPromoPopup(cfg);
        })
        .catch(function() { showPromoPopup(cfg); });
    } catch(e) { showPromoPopup(cfg); }
  }

  if (window.location.pathname === '/social' || window.location.pathname.indexOf('/social') === 0) {
    setTimeout(fetchAndShowPromo, 1000);
  }

})();
