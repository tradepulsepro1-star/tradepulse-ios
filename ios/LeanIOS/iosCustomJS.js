// TradePulse iOS — Native feel + Splash + Custom Sign-In + Guru Leagues promo

(function() {

  var SPLASH_KEY = 'tp_splash_shown';
  var PROMO_KEY  = 'tp_promo_shown';

  // ── CLAIM SPLASH IMMEDIATELY (before any DOM exists) ─────────────────
  // This prevents any race condition — we own this session's splash right now
  var splashNeeded = !sessionStorage.getItem(SPLASH_KEY);
  if (splashNeeded) {
    sessionStorage.setItem(SPLASH_KEY, '1');
  }

  // ── WAIT FOR DOM THEN DO EVERYTHING ──────────────────────────────────
  function onDOMReady(fn) {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', fn);
    } else {
      fn();
    }
  }

  onDOMReady(function() {

    // ── NATIVE FEEL CSS ─────────────────────────────────────────────────
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
      'body { -webkit-text-size-adjust: none !important; text-size-adjust: none !important; }'
    ].join('\n');
    document.head.appendChild(style);

    document.documentElement.style.backgroundColor = '#0A0E1A';
    if (document.body) document.body.style.backgroundColor = '#0A0E1A';

    // ── PREVENT CONTEXT MENU ──────────────────────────────────────────
    document.addEventListener('contextmenu', function(e) { e.preventDefault(); return false; }, true);
    document.addEventListener('selectstart', function(e) {
      if (!e.target.matches('input, textarea, [contenteditable]')) e.preventDefault();
    }, true);

    // ── HELPERS ───────────────────────────────────────────────────────
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

    function isSignInPage() {
      var p = window.location.pathname;
      return p === '/sign-in' || p === '/signin' || p === '/login';
    }

    // ── SPLASH SCREEN ──────────────────────────────────────────────────
    var SPLASH_IMAGE    = 'https://base44.app/api/apps/69df5ede5be1d2722b8e2c66/files/mp/public/69df5ede5be1d2722b8e2c66/b2b76b879_d2a391939_image.png';
    var SPLASH_DURATION = 8000;

    function showSplash() {
      var overlay = document.createElement('div');
      overlay.id = 'tp-splash';
      overlay.style.cssText = 'position:fixed;inset:0;z-index:9999999;background:#000;opacity:1;transition:opacity 0.7s ease';

      var bg = document.createElement('div');
      bg.style.cssText = 'position:absolute;inset:0;background-image:url(' + SPLASH_IMAGE + ');background-size:contain;background-position:center;background-repeat:no-repeat';
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
            if (hasAuthToken()) {
              if (window.location.pathname !== '/social') {
                window.location.replace('/social');
              }
            } else {
              if (isSignInPage()) {
                injectSignInOverlay();
              } else {
                window.location.replace('/sign-in');
              }
            }
          }, 720);
        }
      }
      requestAnimationFrame(tick);
    }

    // ── CUSTOM SIGN-IN OVERLAY ─────────────────────────────────────────
    var LOGO_URL = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/cbc23e8b7_837162d7-468e-4545-95c3-d07bb0aaea7f.png';

    function injectSignInOverlay() {
      if (document.getElementById('tp-signin-overlay')) return;

      document.documentElement.style.background = '#0A0E1A';
      if (document.body) document.body.style.background = '#0A0E1A';

      var overlay = document.createElement('div');
      overlay.id = 'tp-signin-overlay';
      overlay.style.cssText = [
        'position:fixed', 'inset:0', 'z-index:9999998', 'background:#0A0E1A',
        'display:flex', 'flex-direction:column', 'align-items:center',
        'justify-content:center', 'padding:0 32px', 'font-family:-apple-system,BlinkMacSystemFont,sans-serif'
      ].join(';');

      overlay.innerHTML = [
        '<img src="' + LOGO_URL + '" style="width:90px;height:90px;border-radius:50%;margin-bottom:24px;object-fit:cover">',
        '<div style="font-size:26px;font-weight:700;color:#fff;margin-bottom:8px">Welcome to TradePulse</div>',
        '<div style="font-size:15px;color:rgba(255,255,255,0.5);margin-bottom:40px;text-align:center">Sign in to continue</div>',
        '<button id="tp-google-btn" style="width:100%;max-width:320px;height:52px;border-radius:14px;background:#fff;border:none;display:flex;align-items:center;justify-content:center;gap:12px;font-size:16px;font-weight:600;color:#1a1a1a;cursor:pointer;margin-bottom:12px">',
        '<svg width="20" height="20" viewBox="0 0 48 48"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/></svg>',
        'Continue with Google</button>',
        '<button id="tp-apple-btn" style="width:100%;max-width:320px;height:52px;border-radius:14px;background:#fff;border:none;display:flex;align-items:center;justify-content:center;gap:12px;font-size:16px;font-weight:600;color:#1a1a1a;cursor:pointer;margin-bottom:32px">',
        '<svg width="20" height="20" viewBox="0 0 814 1000"><path d="M788.1 340.9c-5.8 4.5-108.2 62.2-108.2 190.5 0 148.4 130.3 200.9 134.2 202.2-.6 3.2-20.7 71.9-68.7 141.9-42.8 61.6-87.5 123.1-155.5 123.1s-85.5-39.5-164-39.5c-76 0-103.7 40.8-165.9 40.8s-105-57.8-155.5-127.4C46 790.7 0 663 0 541.8c0-207.5 135.4-317.3 269-317.3 70.1 0 128.4 46.4 172.5 46.4 42.8 0 109.6-49 192.5-49 30.8 0 133.2 2.6 199.3 99zm-234-181.5c31.1-36.9 53.1-88.1 53.1-139.3 0-7.1-.6-14.3-1.9-20.1-50.6 1.9-110.8 33.7-147.1 75.8-28.5 32.4-55.1 83.6-55.1 135.5 0 7.8 1.3 15.6 1.9 18.1 3.2.6 8.4 1.3 13.6 1.3 45.4 0 102.5-30.4 135.5-71.3z" fill="#000"/></svg>',
        'Continue with Apple</button>',
        '<div style="display:flex;align-items:center;gap:12px;width:100%;max-width:320px;margin-bottom:24px">',
        '<div style="flex:1;height:1px;background:rgba(255,255,255,0.1)"></div>',
        '<span style="color:rgba(255,255,255,0.3);font-size:13px">OR</span>',
        '<div style="flex:1;height:1px;background:rgba(255,255,255,0.1)"></div></div>',
        '<input id="tp-email" type="email" placeholder="Email" style="width:100%;max-width:320px;height:52px;border-radius:14px;background:rgba(255,255,255,0.07);border:1.5px solid rgba(255,255,255,0.12);color:#fff;font-size:16px;padding:0 16px;margin-bottom:12px;box-sizing:border-box;-webkit-user-select:text!important;user-select:text!important">',
        '<input id="tp-pass" type="password" placeholder="Password" style="width:100%;max-width:320px;height:52px;border-radius:14px;background:rgba(255,255,255,0.07);border:1.5px solid rgba(255,255,255,0.12);color:#fff;font-size:16px;padding:0 16px;margin-bottom:16px;box-sizing:border-box;-webkit-user-select:text!important;user-select:text!important">',
        '<button id="tp-signin-btn" style="width:100%;max-width:320px;height:52px;border-radius:14px;background:#F5C842;border:none;font-size:16px;font-weight:700;color:#0A0E1A;cursor:pointer;margin-bottom:16px">Sign In</button>',
        '<a id="tp-forgot" style="color:rgba(255,255,255,0.4);font-size:14px;margin-bottom:8px;cursor:pointer">Forgot password?</a>',
        '<div style="color:rgba(255,255,255,0.4);font-size:14px">Need an account? <span id="tp-signup" style="color:#F5C842;font-weight:600;cursor:pointer">Sign up</span></div>'
      ].join('');

      document.body.appendChild(overlay);

      // Google button
      document.getElementById('tp-google-btn').addEventListener('click', function() {
        var redirectUri = encodeURIComponent('https://tradepulsepro.net/sign-in');
        var clientId = '393001366701-5uh7a36evemmbes17ae9cmlkbr14ufrf.apps.googleusercontent.com';
        var scope = encodeURIComponent('openid email profile');
        var authUrl = 'https://accounts.google.com/o/oauth2/v2/auth?client_id=' + clientId +
          '&redirect_uri=' + redirectUri + '&response_type=token&scope=' + scope;
        window.location.href = authUrl;
      });

      // Apple button
      document.getElementById('tp-apple-btn').addEventListener('click', function() {
        window.location.href = 'https://tradepulsepro.net/sign-in?method=apple';
      });

      // Email sign in
      document.getElementById('tp-signin-btn').addEventListener('click', function() {
        var email = document.getElementById('tp-email').value;
        var pass = document.getElementById('tp-pass').value;
        if (email && pass) {
          var ol = document.getElementById('tp-signin-overlay');
          if (ol) ol.parentNode.removeChild(ol);
        }
      });

      // Sign up
      document.getElementById('tp-signup').addEventListener('click', function() {
        window.location.href = '/sign-up';
      });

      // Forgot password
      document.getElementById('tp-forgot').addEventListener('click', function() {
        window.location.href = '/forgot-password';
      });
    }

    // ── INIT ───────────────────────────────────────────────────────────
    if (splashNeeded) {
      showSplash();
    } else if (isSignInPage()) {
      injectSignInOverlay();
    }

    // ── GURU LEAGUES PROMO POPUP ───────────────────────────────────────
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
        fetch('/api/functions/getMobilePromoConfig')
          .then(function(r) { return r.json(); })
          .then(function(d) {
            if (d && d.image) { cfg.image = d.image; cfg.enabled = d.enabled !== false; cfg.label = d.label || cfg.label; }
            showPromoPopup(cfg);
          })
          .catch(function() { showPromoPopup(cfg); });
      } catch(e) { showPromoPopup(cfg); }
    }

    // ── SPA NAVIGATION WATCHER ─────────────────────────────────────────
    var lastPath = window.location.pathname;

    setInterval(function() {
      var cur = window.location.pathname;
      if (cur !== lastPath) {
        lastPath = cur;

        if (cur !== '/sign-in' && cur !== '/signin') {
          var ol = document.getElementById('tp-signin-overlay');
          if (ol && ol.parentNode) ol.parentNode.removeChild(ol);
        }

        if (cur === '/social' || cur.indexOf('/social') === 0) {
          setTimeout(fetchAndShowPromo, 800);
        }
      }
    }, 250);

    // Fire promo if already on /social, check multiple times to catch splash redirect
    [1000, 2000, 3000].forEach(function(delay) {
      setTimeout(function() {
        var cur = window.location.pathname;
        if (cur === '/social' || cur.indexOf('/social') === 0) {
          fetchAndShowPromo();
        }
      }, delay);
    });

  }); // end onDOMReady

})();
