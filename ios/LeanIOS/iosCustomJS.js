// TradePulse iOS — Native feel + Splash + Guru Leagues promo + Apple IAP
// NO custom sign-in overlay — Base44 auth handles sign-in natively

(function() {

  var SPLASH_KEY = 'tp_splash_shown';
  var PROMO_KEY  = 'tp_promo_shown';

  // ── CLAIM SPLASH SLOT IMMEDIATELY (before DOM) ────────────────────────
  var splashNeeded = !sessionStorage.getItem(SPLASH_KEY);
  if (splashNeeded) sessionStorage.setItem(SPLASH_KEY, '1');

  // ── DOM READY HELPER ──────────────────────────────────────────────────
  function onDOMReady(fn) {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', fn);
    } else {
      fn();
    }
  }

  onDOMReady(function() {

    // ── NATIVE FEEL CSS ───────────────────────────────────────────────
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
      // Hide web-only payment buttons in native app
      '.stripe-payment-btn, .web-payment-only, [data-payment="stripe"] { display: none !important; }',
      // Show IAP buttons only in native app
      '.iap-payment-btn { display: block !important; }'
    ].join('\n');
    document.head.appendChild(style);

    document.documentElement.style.backgroundColor = '#0A0E1A';
    if (document.body) document.body.style.backgroundColor = '#0A0E1A';

    // ── PREVENT CONTEXT MENU ──────────────────────────────────────────
    document.addEventListener('contextmenu', function(e) { e.preventDefault(); return false; }, true);
    document.addEventListener('selectstart', function(e) {
      if (!e.target.matches('input, textarea, [contenteditable]')) e.preventDefault();
    }, true);

    // ── APPLE IAP — Gold Bar Store ────────────────────────────────────
    // Product IDs must match App Store Connect exactly
    var IAP_PRODUCTS = {
      starter:   'net.tradepulsepro.goldbars.starter',
      value:     'net.tradepulsepro.goldbars.value',
      pro:       'net.tradepulsepro.goldbars.pro',
      elite:     'net.tradepulsepro.goldbars.elite',
      sub_starter: 'net.tradepulsepro.sub.starter',
      sub_value:   'net.tradepulsepro.sub.value',
      sub_pro:     'net.tradepulsepro.sub.pro',
      sub_elite:   'net.tradepulsepro.sub.elite'
    };

    // Expose IAP trigger globally so React components can call it
    window.tp_iap_purchase = function(productKey) {
      var productId = IAP_PRODUCTS[productKey];
      if (!productId) { console.warn('TradePulse IAP: unknown product', productKey); return; }
      if (window.gonative && window.gonative.purchases && window.gonative.purchases.purchase) {
        window.gonative.purchases.purchase({ productId: productId });
      } else if (window.median && window.median.purchases && window.median.purchases.purchase) {
        window.median.purchases.purchase({ productId: productId });
      } else {
        console.warn('TradePulse IAP: native bridge not available');
      }
    };

    // Listen for IAP results from native bridge
    window.addEventListener('message', function(e) {
      if (!e.data || e.data.type !== 'gonative.purchases.result') return;
      var result = e.data;
      if (result.status === 'success') {
        // Notify the React app that purchase succeeded
        window.dispatchEvent(new CustomEvent('tp_iap_success', { detail: result }));
      } else if (result.status === 'cancelled') {
        window.dispatchEvent(new CustomEvent('tp_iap_cancelled', { detail: result }));
      } else {
        window.dispatchEvent(new CustomEvent('tp_iap_error', { detail: result }));
      }
    });

    // ── GOLD BAR STORE PAGE — inject IAP UI ───────────────────────────
    function patchGoldBarStore() {
      // Find all "BUY ONCE" and "SUBSCRIBE / MONTH" buttons and rewire them
      var btns = document.querySelectorAll('button');
      btns.forEach(function(btn) {
        var txt = (btn.textContent || '').trim().toUpperCase();
        if (txt === 'BUY ONCE' || txt === 'SUBSCRIBE / MONTH') {
          // Already patched
          if (btn.getAttribute('data-iap-patched')) return;
          btn.setAttribute('data-iap-patched', '1');

          // Detect which package this button belongs to by walking up the DOM
          var card = btn.closest('[class*="card"], [class*="package"], [class*="tier"], section, article, div[class]');
          var cardText = card ? (card.textContent || '').toUpperCase() : '';
          var productKey = 'starter';
          if (cardText.indexOf('ELITE') !== -1)        productKey = txt === 'BUY ONCE' ? 'elite'   : 'sub_elite';
          else if (cardText.indexOf('PRO') !== -1)     productKey = txt === 'BUY ONCE' ? 'pro'     : 'sub_pro';
          else if (cardText.indexOf('VALUE') !== -1)   productKey = txt === 'BUY ONCE' ? 'value'   : 'sub_value';
          else                                          productKey = txt === 'BUY ONCE' ? 'starter' : 'sub_starter';

          // Replace click handler with IAP trigger
          var newBtn = btn.cloneNode(true);
          newBtn.setAttribute('data-iap-patched', '1');
          newBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            window.tp_iap_purchase(productKey);
          });
          btn.parentNode.replaceChild(newBtn, btn);
        }
      });
    }

    // Watch for Gold Bar Store page navigation
    function checkAndPatchStore() {
      var path = window.location.pathname;
      if (path.indexOf('gold') !== -1 || path.indexOf('store') !== -1 || path.indexOf('purchase') !== -1 || path.indexOf('wallet') !== -1) {
        setTimeout(patchGoldBarStore, 500);
        setTimeout(patchGoldBarStore, 1500);
        setTimeout(patchGoldBarStore, 3000);
      }
      // Also patch on any page in case Gold Bar Store is a modal
      setTimeout(patchGoldBarStore, 1000);
    }

    // ── SPLASH SCREEN ─────────────────────────────────────────────────
    var SPLASH_IMAGE    = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
    var SPLASH_DURATION = 8000;

    function showSplash() {
      var overlay = document.createElement('div');
      overlay.id = 'tp-splash';
      overlay.style.cssText = 'position:fixed;inset:0;z-index:9999999;background:#000;opacity:1;transition:opacity 0.7s ease';

      var bg = document.createElement('div');
      bg.style.cssText = 'position:absolute;inset:0;background-image:url(' + SPLASH_IMAGE + ');background-size:cover;background-position:center';
      overlay.appendChild(bg);

      var track = document.createElement('div');
      track.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
      var fill = document.createElement('div');
      fill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px';
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
          }, 720);
        }
      }
      requestAnimationFrame(tick);
    }

    if (splashNeeded) {
      showSplash();
    }

    // ── GURU LEAGUES PROMO POPUP ──────────────────────────────────────
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

      var promoTrack = document.createElement('div');
      promoTrack.style.cssText = 'position:absolute;bottom:48px;left:32px;right:32px;height:3px;background:rgba(255,255,255,0.12);border-radius:100px;overflow:hidden';
      var promoFill = document.createElement('div');
      promoFill.style.cssText = 'height:100%;width:0%;background:linear-gradient(90deg,#B8860B,#F5C842,#FFD700);border-radius:100px';
      promoTrack.appendChild(promoFill);
      popup.appendChild(promoTrack);

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
      xBtn.textContent = '\u2715';
      xBtn.style.cssText = 'position:absolute;top:52px;right:20px;z-index:10;width:36px;height:36px;border-radius:50%;background:rgba(0,0,0,0.6);border:1.5px solid rgba(255,255,255,0.25);color:#fff;font-size:15px;cursor:pointer;-webkit-appearance:none;line-height:36px;text-align:center;font-family:-apple-system,sans-serif';
      xBtn.addEventListener('click', dismiss);
      popup.appendChild(xBtn);

      document.body.appendChild(popup);
      setTimeout(function() { backdrop.style.opacity = '1'; popup.style.opacity = '1'; }, 50);

      var duration = cfg.duration || 6000;
      var pStart = Date.now();
      function promoTick() {
        var pct = Math.min(((Date.now() - pStart) / duration) * 100, 100);
        promoFill.style.width = pct + '%';
        if (pct < 100) {
          requestAnimationFrame(promoTick);
        } else {
          dismiss();
        }
      }
      requestAnimationFrame(promoTick);
    }

    function fetchAndShowPromo() {
      if (sessionStorage.getItem(PROMO_KEY)) return;
      var cfg = { image: PROMO_FALLBACK, enabled: true, label: '\u26a1 Guru Leagues — Coming Soon', duration: 6000 };
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

    // ── SPA NAVIGATION WATCHER ────────────────────────────────────────
    var _origPush    = history.pushState.bind(history);
    var _origReplace = history.replaceState.bind(history);

    function onNavigation() {
      var cur = window.location.pathname;
      if (cur === '/social' || cur.indexOf('/social') === 0) {
        setTimeout(fetchAndShowPromo, 800);
      }
      checkAndPatchStore();
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

    // Check on load
    if (window.location.pathname === '/social' || window.location.pathname.indexOf('/social') === 0) {
      setTimeout(fetchAndShowPromo, 1000);
    }
    checkAndPatchStore();

  }); // end onDOMReady

})();
