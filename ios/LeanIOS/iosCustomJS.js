// TradePulse iOS — v2 clean
// initialUrl is now /sign-in — no landing page logic needed

(function() {

  // ── NATIVE FEEL ───────────────────────────────────────────────────────
  function injectStyles() {
    var s = document.createElement('style');
    s.textContent = [
      '* { -webkit-user-select:none!important; user-select:none!important; }',
      'input,textarea,[contenteditable]{ -webkit-user-select:text!important; user-select:text!important; }',
      '* { -webkit-tap-highlight-color:transparent!important; }',
      '* { -webkit-touch-callout:none!important; }',
      'html,body{ overscroll-behavior:none; }'
    ].join('');
    document.head.appendChild(s);
  }
  if (document.head) { injectStyles(); }
  else { document.addEventListener('DOMContentLoaded', injectStyles); }

  document.addEventListener('contextmenu', function(e){ e.preventDefault(); }, true);

  // ── iOS 26 BLACK SCREEN FIX ───────────────────────────────────────────
  function repaint() {
    document.body.style.display = 'none';
    void document.body.offsetHeight;
    document.body.style.display = '';
  }
  window.addEventListener('load', function() {
    repaint();
    var n = 0;
    var t = setInterval(function(){ repaint(); if (++n >= 6) clearInterval(t); }, 500);
  });

  // ── SPLASH SCREEN ─────────────────────────────────────────────────────
  // Shows once per session immediately on first page load (sign-in page)
  var SPLASH_KEY = 'tp_splash_shown';
  var SPLASH_IMG = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
  var SPLASH_MS  = 8000;

  function showSplash() {
    // Always show on cold open — no session gate

    var ov = document.createElement('div');
    ov.style.cssText = 'position:fixed;inset:0;z-index:9999999;background:#000;opacity:1;transition:opacity 0.6s ease';

    var bg = document.createElement('div');
    bg.style.cssText = 'position:absolute;inset:0;background:url(' + SPLASH_IMG + ') center/cover no-repeat';
    ov.appendChild(bg);

    var track = document.createElement('div');
    track.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.15);border-radius:99px;overflow:hidden';
    var fill = document.createElement('div');
    fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:99px';
    track.appendChild(fill);
    ov.appendChild(track);
    document.body.appendChild(ov);

    var start = Date.now();
    (function tick() {
      var pct = Math.min(((Date.now() - start) / SPLASH_MS) * 100, 100);
      fill.style.width = pct + '%';
      if (pct < 100) { requestAnimationFrame(tick); }
      else {
        ov.style.opacity = '0';
        setTimeout(function() { ov.parentNode && ov.parentNode.removeChild(ov); }, 650);
      }
    })();
  }

  if (document.readyState === 'loading') { document.addEventListener('DOMContentLoaded', showSplash); }
  else { showSplash(); }

  // ── PROMO OVERLAY ─────────────────────────────────────────────────────
  // Shows once per session when user lands on /social (after sign-in)
  var PROMO_KEY = 'tp_promo_shown';
  var PROMO_IMG = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/f0d93aec4_ChatGPTImageMay15202603_07_35PM.png';

  function showPromo(cfg) {
    if (sessionStorage.getItem(PROMO_KEY)) return;
    if (!cfg.enabled) return;
    sessionStorage.setItem(PROMO_KEY, '1');

    var ov = document.createElement('div');
    ov.style.cssText = 'position:fixed;inset:0;z-index:999999;background:#0A0E1A;opacity:0;transition:opacity 0.35s ease';

    var bg = document.createElement('div');
    bg.style.cssText = 'position:absolute;inset:0;background:url(' + cfg.image + ') center/cover no-repeat';
    ov.appendChild(bg);

    var grad = document.createElement('div');
    grad.style.cssText = 'position:absolute;bottom:0;left:0;right:0;height:160px;background:linear-gradient(to top,rgba(10,14,26,0.95),transparent)';
    ov.appendChild(grad);

    var lbl = document.createElement('div');
    lbl.textContent = cfg.label || '⚡ Guru Leagues — Coming Soon';
    lbl.style.cssText = 'position:absolute;bottom:80px;left:0;right:0;text-align:center;color:#F5C842;font-size:15px;font-weight:600;font-family:-apple-system,sans-serif';
    ov.appendChild(lbl);

    var xBtn = document.createElement('button');
    xBtn.textContent = '✕';
    xBtn.style.cssText = 'position:absolute;top:52px;right:20px;width:36px;height:36px;border-radius:50%;background:rgba(0,0,0,0.55);border:1.5px solid rgba(255,255,255,0.25);color:#fff;font-size:15px;cursor:pointer;-webkit-appearance:none;display:flex;align-items:center;justify-content:center;font-family:-apple-system,sans-serif';
    xBtn.addEventListener('click', dismiss);
    ov.appendChild(xBtn);

    // Bar timer
    var track = document.createElement('div');
    track.style.cssText = 'position:absolute;bottom:52px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:99px;overflow:hidden';
    var fill = document.createElement('div');
    fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:99px';
    track.appendChild(fill);
    ov.appendChild(track);

    document.body.appendChild(ov);
    setTimeout(function(){ ov.style.opacity = '1'; }, 30);

    var dur = cfg.duration || 6000;
    var start = Date.now();
    (function tick() {
      var pct = Math.min(((Date.now() - start) / dur) * 100, 100);
      fill.style.width = pct + '%';
      if (pct < 100) { requestAnimationFrame(tick); }
      else { dismiss(); }
    })();

    function dismiss() {
      ov.style.opacity = '0';
      setTimeout(function(){ ov.parentNode && ov.parentNode.removeChild(ov); }, 380);
    }
  }

  function fetchAndShowPromo() {
    if (sessionStorage.getItem(PROMO_KEY)) return;
    var cfg = { image: PROMO_IMG, enabled: true, label: '⚡ Guru Leagues — Coming Soon', duration: 6000 };
    try {
      fetch('https://tradepulsepro.net/api/functions/getMobilePromoConfig')
        .then(function(r){ return r.json(); })
        .then(function(d){
          if (d && d.image)    cfg.image    = d.image;
          if (d && d.label)    cfg.label    = d.label;
          if (d && d.duration) cfg.duration = d.duration;
          if (d)               cfg.enabled  = d.enabled !== false;
          showPromo(cfg);
        })
        .catch(function(){ showPromo(cfg); });
    } catch(e) { showPromo(cfg); }
  }

  // ── SPA NAV WATCHER — trigger promo on /social ─────────────────────
  var lastPath = location.pathname;
  setInterval(function() {
    var cur = location.pathname;
    if (cur !== lastPath) {
      lastPath = cur;
      if (cur === '/social' || cur.indexOf('/social') === 0) {
        setTimeout(fetchAndShowPromo, 800);
      }
    }
  }, 400);

  // In case app opens directly on /social (already signed in)
  if (location.pathname === '/social' || location.pathname.indexOf('/social') === 0) {
    setTimeout(fetchAndShowPromo, 1200);
  }

})();
