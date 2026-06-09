// TradePulse iOS — Native feel + Splash + Guru Leagues promo + Apple IAP
// NO custom sign-in overlay — Base44 auth handles sign-in natively

(function() {

  // ── NATIVE FLAG — set before React loads so GoldBarStore never falls through to Apple Pay JS ──
  window.tp_is_native_ios = true;

  var SPLASH_KEY = 'tp_splash_shown';
  var PROMO_KEY  = 'tp_promo_shown';

  // ── SPLASH GATE — block React routing until splash finishes ──────────
  // We do NOT set tp_splash_shown yet — React reads it as "splash done"
  // We block history navigation for 8s so React auth can't redirect during splash
  var _splashShown = !!sessionStorage.getItem(SPLASH_KEY);

  if (!_splashShown) {
    // Lock navigation immediately — before DOM, before React loads
    var _origPush    = history.pushState.bind(history);
    var _origReplace = history.replaceState.bind(history);
    var _navLocked   = true;

    history.pushState = function(state, title, url) {
      if (_navLocked) return;
      return _origPush(state, title, url);
    };
    history.replaceState = function(state, title, url) {
      if (_navLocked) return;
      return _origReplace(state, title, url);
    };

    // Unlock after 8s and signal React that splash is done
    setTimeout(function() {
      _navLocked = false;
      history.pushState    = _origPush;
      history.replaceState = _origReplace;
      sessionStorage.setItem(SPLASH_KEY, '1'); // NOW signal React — splash is done
    }, 8000);
  }

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
      '.stripe-payment-btn, .web-payment-only, [data-payment="stripe"] { display: none !important; }',
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
      if (window.gonative && window.gonative.purchases && window.gonative.purchases.purchase) {
        window.gonative.purchases.purchase({ productId: productId });
      } else if (window.median && window.median.purchases && window.median.purchases.purchase) {
        window.median.purchases.purchase({ productId: productId });
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
      if (bridge && bridge.purchase) {
        bridge.purchase({ productId: productId });
      }
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
              var productId = getIAPProductId(el);
              triggerIAP(productId);
              return false;
            }
          }
          el = el.parentElement;
        }
      }, true);
    }

    // ── SPLASH SCREEN ─────────────────────────────────────────────────
    var SPLASH_IMAGE    = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
    var SPLASH_DURATION = 8000;

    function showSplash() {
      var overlay = document.createElement('div');
      overlay.id = 'tp-splash';
      overlay.style.cssText = 'position:fixed;inset:0;z-index:9999999;background:#0A0E1A;opacity:1;transition:opacity 0.7s ease';

      // Use <img> not background-image — more reliable on iOS 26 WKWebView
      var img = document.createElement('img');
      img.src = SPLASH_IMAGE;
      img.style.cssText = 'position:absolute;inset:0;width:100%;height:100%;object-fit:cover;display:block';
      overlay.appendChild(img);

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

    if (!_splashShown) {
      showSplash();
    }

    // ── iOS 26 WKWEBVIEW REPAINT FIX ──────────────────────────────────
    function forceRepaint() {
      if (!document.body) return;
      document.body.style.display = 'none';
      void document.body.offsetHeight;
      document.body.style.display = '';
    }
    forceRepaint();
    var _rp = 0;
    var _rpTimer = setInterval(function() {
      forceRepaint(); _rp++;
      if (_rp >= 6) clearInterval(_rpTimer);
    }, 500);

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
      lbl.textContent = cfg.label || '\u26a1 Coming Soon';
      lbl.style.cssText = 'position:absolute;bottom:80px;left:0;right:0;text-align:center;color:#F5C842;font-size:15px;font-weight:600;font-family:sans-serif;letter-spacing:0.3px';
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
      xBtn.style.cssText = 'position:absolute;top:52px;right:20px;z-index:10;width:36px;height:36px;border-radius:50%;background:rgba(0,0,0,0.6);border:1.5px solid rgba(255,255,255,0.25);color:#fff;font-size:15px;cursor:pointer;line-height:36px;text-align:center;font-family:sans-serif';
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

    // ── SPA NAVIGATION WATCHER ────────────────────────────────────────
    var _origPushSPA    = history.pushState.bind(history);
    var _origReplaceSPA = history.replaceState.bind(history);

    function onNavigation() {
      var cur = window.location.pathname;
      if (cur === '/social' || cur.indexOf('/social') === 0) {
        setTimeout(fetchAndShowPromo, 800);
      }
    }

    history.pushState = function() {
      _origPushSPA.apply(history, arguments);
      setTimeout(onNavigation, 100);
    };
    history.replaceState = function() {
      _origReplaceSPA.apply(history, arguments);
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
