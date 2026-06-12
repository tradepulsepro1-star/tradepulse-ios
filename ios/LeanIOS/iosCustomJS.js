// TradePulse iOS — Native feel + Splash + Guru Leagues promo + Apple IAP
// Build 148 — splash fires immediately (pre-DOM), localStorage-based to survive auth reloads

(function() {

  var SPLASH_KEY    = 'tp_splash_ts';
  var PROMO_KEY     = 'tp_promo_shown';
  var COLD_THRESHOLD = 30000; // 30s — new cold open

  // ── COLD OPEN DETECTION (localStorage — survives auth page reloads) ─
  var now    = Date.now();
  var lastTs = 0;
  try { lastTs = parseInt(localStorage.getItem(SPLASH_KEY) || '0'); } catch(e) {}
  var splashNeeded = (now - lastTs) > COLD_THRESHOLD;
  if (splashNeeded) {
    try { localStorage.setItem(SPLASH_KEY, String(now)); } catch(e) {}
    try { localStorage.removeItem(PROMO_KEY); } catch(e) {}
  }

  // ── SPLASH — inject IMMEDIATELY before DOM parses (blocks the flash) ─
  var SPLASH_IMAGE    = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
  var SPLASH_DURATION = 8000;
  var splashEl        = null;
  var splashStarted   = false;

  function injectSplash() {
    if (splashEl || !document.documentElement) return false;

    // Create overlay immediately on <html> before <body> exists
    splashEl = document.createElement('div');
    splashEl.id = 'tp-splash';
    splashEl.style.cssText = [
      'position:fixed',
      'inset:0',
      'z-index:2147483647',
      'background:#0A0E1A',
      'opacity:1',
      '-webkit-transition:opacity 0.7s ease',
      'transition:opacity 0.7s ease'
    ].join(';');

    var bg = document.createElement('div');
    bg.style.cssText = 'position:absolute;inset:0;background-image:url(' + SPLASH_IMAGE + ');background-size:cover;background-position:center;background-repeat:no-repeat';
    splashEl.appendChild(bg);

    var track = document.createElement('div');
    track.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
    var fill = document.createElement('div');
    fill.id = 'tp-splash-fill';
    fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px;-webkit-transition:none;transition:none';
    track.appendChild(fill);
    splashEl.appendChild(track);

    // Attach to documentElement if body not ready yet
    var parent = document.body || document.documentElement;
    parent.insertBefore(splashEl, parent.firstChild);
    return true;
  }

  function startSplashTimer() {
    if (splashStarted) return;
    splashStarted = true;
    var fill = document.getElementById('tp-splash-fill');
    var overlay = document.getElementById('tp-splash');
    if (!fill || !overlay) return;

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
        }, 720);
      }
    }
    requestAnimationFrame(tick);
  }

  if (splashNeeded) {
    // Try immediately — document.documentElement is available synchronously
    if (!injectSplash()) {
      var retryInterval = setInterval(function() {
        if (injectSplash()) clearInterval(retryInterval);
      }, 10);
    }
    // Start timer once body exists
    if (document.body) {
      startSplashTimer();
    } else {
      document.addEventListener('DOMContentLoaded', startSplashTimer);
    }
  }

  // ── iOS 26 REPAINT FIX ────────────────────────────────────────────
  function forceRepaint() {
    if (!document.body) return;
    document.body.style.display = 'none';
    void document.body.offsetHeight;
    document.body.style.display = '';
  }

  // ── DOM READY ─────────────────────────────────────────────────────
  function onDOMReady(fn) {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', fn);
    } else {
      fn();
    }
  }

  onDOMReady(function() {

    // Repaint fix (iOS 26 WKWebView)
    forceRepaint();
    var repaintCount = 0;
    var repaintTimer = setInterval(function() {
      forceRepaint(); repaintCount++;
      if (repaintCount >= 6) clearInterval(repaintTimer);
    }, 500);

    // ── NATIVE FEEL CSS ───────────────────────────────────────────
    var style = document.createElement('style');
    style.textContent = [
      '* { -webkit-user-select: none !important; user-select: none !important; }',
      'input, textarea, [contenteditable] { -webkit-user-select: text !important; user-select: text !important; }',
      '* { -webkit-tap-highlight-color: transparent !important; }',
      '* { -webkit-touch-callout: none !important; }',
      '* { -webkit-font-smoothing: antialiased; }',
      'body { overscroll-behavior: none !important; overflow-y: scroll; }',
      'html { overscroll-behavior: none !important; }',
      'input, textarea, select { font-size: 16px !important; }',
      'html, body { background-color: #0A0E1A !important; }',
      '::-webkit-scrollbar { display: none !important; }',
      'body { -webkit-text-size-adjust: none !important; text-size-adjust: none !important; }',
      '.stripe-payment-btn, .web-payment-only, [data-payment="stripe"] { display: none !important; }',
      '.iap-payment-btn { display: block !important; }'
    ].join('\n');
    document.head.appendChild(style);

    document.documentElement.style.backgroundColor = '#0A0E1A';
    if (document.body) document.body.style.backgroundColor = '#0A0E1A';

    document.addEventListener('contextmenu', function(e) { e.preventDefault(); return false; }, true);
    document.addEventListener('selectstart', function(e) {
      if (!e.target.matches('input, textarea, [contenteditable]')) e.preventDefault();
    }, true);

    // ── APPLE IAP ─────────────────────────────────────────────────
    var IAP_PRODUCTS = {
      starter:     'net.tradepulsepro.goldbars.starter',
      value:       'net.tradepulsepro.goldbars.value',
      pro:         'net.tradepulsepro.goldbars.pro',
      elite:       'net.tradepulsepro.goldbars.elite',
      sub_starter: 'net.tradepulsepro.sub.starter',
      sub_value:   'net.tradepulsepro.sub.value',
      sub_pro:     'net.tradepulsepro.sub.pro',
      sub_elite:   'net.tradepulsepro.sub.elite'
    };

    window.tp_iap_purchase = function(productKey) {
      var productId = IAP_PRODUCTS[productKey];
      if (!productId) { console.warn('TradePulse IAP: unknown product', productKey); return; }
      var bridge = (window.gonative && window.gonative.purchases) || (window.median && window.median.purchases);
      if (bridge && bridge.purchase) {
        bridge.purchase({ productId: productId });
      } else {
        console.warn('TradePulse IAP: native bridge not available');
      }
    };

    window.addEventListener('message', function(e) {
      if (!e.data || e.data.type !== 'gonative.purchases.result') return;
      var result = e.data;
      if (result.status === 'success') {
        window.dispatchEvent(new CustomEvent('tp_iap_success', { detail: result }));
      } else if (result.status === 'cancelled') {
        window.dispatchEvent(new CustomEvent('tp_iap_cancelled', { detail: result }));
      } else {
        window.dispatchEvent(new CustomEvent('tp_iap_error', { detail: result }));
      }
    });

    var isNativeIOS = !!(window.gonative || window.median || /GoNative|Median/i.test(navigator.userAgent));

    function getIAPProductId(btn) {
      var txt = (btn.textContent || '').trim().toUpperCase();
      var card = btn.closest('[class*="card"], [class*="package"], [class*="tier"], [class*="plan"], section, article, li, div');
      var cardText = card ? (card.textContent || '').toUpperCase() : '';
      var isSubscribe = (txt === 'SUBSCRIBE / MONTH' || txt === 'SUBSCRIBE');
      if (isSubscribe) {
        if      (cardText.indexOf('ELITE') !== -1) return 'net.tradepulsepro.sub.elite';
        else if (cardText.indexOf('PRO') !== -1)   return 'net.tradepulsepro.sub.pro';
        else if (cardText.indexOf('VALUE') !== -1) return 'net.tradepulsepro.sub.value';
        else                                        return 'net.tradepulsepro.sub.starter';
      } else {
        if      (cardText.indexOf('ELITE') !== -1) return 'net.tradepulsepro.goldbars.elite';
        else if (cardText.indexOf('PRO') !== -1)   return 'net.tradepulsepro.goldbars.pro';
        else if (cardText.indexOf('VALUE') !== -1) return 'net.tradepulsepro.goldbars.value';
        else                                        return 'net.tradepulsepro.goldbars.starter';
      }
    }

    function triggerIAP(productId) {
      var bridge = (window.gonative && window.gonative.purchases) || (window.median && window.median.purchases);
      if (bridge && bridge.purchase) bridge.purchase({ productId: productId });
    }

    if (isNativeIOS) {
      document.addEventListener('click', function(e) {
        var el = e.target;
        for (var i = 0; i < 5; i++) {
          if (!el || el === document) break;
          if (el.tagName === 'BUTTON' || el.tagName === 'A') {
            var txt = (el.textContent || '').trim().toUpperCase();
            if (txt === 'BUY ONCE' || txt === 'SUBSCRIBE / MONTH' || txt === 'SUBSCRIBE' || txt === 'BUY NOW' || txt === 'PURCHASE') {
              e.preventDefault();
              e.stopPropagation();
              e.stopImmediatePropagation();
              triggerIAP(getIAPProductId(el));
              return false;
            }
          }
          el = el.parentElement;
        }
      }, true);
    }

    // ── GURU LEAGUES PROMO POPUP ──────────────────────────────────
    var PROMO_FALLBACK = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/f0d93aec4_ChatGPTImageMay15202603_07_35PM.png';

    function showPromoPopup(cfg) {
      if (!cfg.enabled) return;
      try { if (localStorage.getItem(PROMO_KEY)) return; } catch(e) {}
      try { localStorage.setItem(PROMO_KEY, '1'); } catch(e) {}

      var backdrop = document.createElement('div');
      backdrop.style.cssText = 'position:fixed;inset:0;z-index:999998;background:rgba(0,0,0,0.75);opacity:0;-webkit-transition:opacity 0.3s ease;transition:opacity 0.3s ease';
      document.body.appendChild(backdrop);

      var popup = document.createElement('div');
      popup.style.cssText = 'position:fixed;inset:0;z-index:999999;background:#0A0E1A;opacity:0;-webkit-transition:opacity 0.35s ease;transition:opacity 0.35s ease';

      var img = document.createElement('div');
      img.style.cssText = 'position:absolute;inset:0;background-image:url(' + cfg.image + ');background-size:cover;background-position:center;background-repeat:no-repeat';
      popup.appendChild(img);

      var grad = document.createElement('div');
      grad.style.cssText = 'position:absolute;bottom:0;left:0;right:0;height:160px;background:linear-gradient(to top,rgba(10,14,26,0.95) 0%,transparent 100%)';
      popup.appendChild(grad);

      var lbl = document.createElement('div');
      lbl.textContent = cfg.label || '\u26a1 Coming Soon';
      lbl.style.cssText = 'position:absolute;bottom:80px;left:0;right:0;text-align:center;color:#F5C842;font-size:15px;font-weight:600;font-family:-apple-system,sans-serif;letter-spacing:0.3px';
      popup.appendChild(lbl);

      var promoTrack = document.createElement('div');
      promoTrack.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
      var promoFill = document.createElement('div');
      promoFill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px';
      promoTrack.appendChild(promoFill);
      popup.appendChild(promoTrack);

      var xBtn = document.createElement('button');
      xBtn.textContent = '\u2715';
      xBtn.style.cssText = 'position:absolute;top:52px;right:20px;z-index:10;width:36px;height:36px;border-radius:50%;background:rgba(0,0,0,0.6);border:1.5px solid rgba(255,255,255,0.25);color:#fff;font-size:15px;cursor:pointer;-webkit-appearance:none;line-height:36px;text-align:center;font-family:-apple-system,sans-serif';

      function dismiss() {
        popup.style.opacity = '0';
        backdrop.style.opacity = '0';
        setTimeout(function() {
          if (popup.parentNode) popup.parentNode.removeChild(popup);
          if (backdrop.parentNode) backdrop.parentNode.removeChild(backdrop);
        }, 350);
      }

      xBtn.addEventListener('click', dismiss);
      backdrop.addEventListener('click', dismiss);
      popup.appendChild(xBtn);
      document.body.appendChild(popup);
      setTimeout(function() { backdrop.style.opacity = '1'; popup.style.opacity = '1'; }, 50);

      var duration = cfg.duration || 6000;
      var pStart = Date.now();
      function promoTick() {
        var pct = Math.min(((Date.now() - pStart) / duration) * 100, 100);
        promoFill.style.width = pct + '%';
        if (pct < 100) { requestAnimationFrame(promoTick); } else { dismiss(); }
      }
      requestAnimationFrame(promoTick);
    }

    function fetchAndShowPromo() {
      try { if (localStorage.getItem(PROMO_KEY)) return; } catch(e) {}
      var cfg = { image: PROMO_FALLBACK, enabled: true, label: '\u26a1 Guru Leagues \u2014 Coming Soon', duration: 6000 };
      try {
        fetch('/api/functions/getMobilePromoConfig')
          .then(function(r) { return r.json(); })
          .then(function(data) {
            if (data && data.image) cfg.image = data.image;
            if (data && typeof data.enabled !== 'undefined') cfg.enabled = data.enabled;
            if (data && data.label) cfg.label = data.label;
            if (data && data.duration) cfg.duration = parseInt(data.duration) || 6000;
            showPromoPopup(cfg);
          })
          .catch(function() { showPromoPopup(cfg); });
      } catch(e) { showPromoPopup(cfg); }
    }

    // ── SPA NAVIGATION WATCHER ────────────────────────────────────
    var _origPush    = history.pushState.bind(history);
    var _origReplace = history.replaceState.bind(history);

    function onNavigation() {
      var cur = window.location.pathname;
      if (cur === '/social' || cur.indexOf('/social') === 0) {
        setTimeout(fetchAndShowPromo, 800);
      }
    }

    history.pushState = function() {
      _origPush.apply(history, arguments);
      setTimeout(onNavigation, 100);
    };
    history.replaceState = function() {
      _origReplace.apply(history, arguments);
      setTimeout(onNavigation, 100);
    };
    window.addEventListener('popstate', function() {
      setTimeout(onNavigation, 100);
    });

    if (window.location.pathname === '/social' || window.location.pathname.indexOf('/social') === 0) {
      setTimeout(fetchAndShowPromo, 1000);
    }

  }); // end onDOMReady

})();
