// TradePulse iOS — Native feel + Splash + Custom Sign-In + Guru Leagues promo

(function() {

  // ── NATIVE FEEL CSS ───────────────────────────────────────────────────
  var style = document.createElement('style');
  style.textContent = [
    // No text selection anywhere except inputs
    '* { -webkit-user-select: none !important; user-select: none !important; }',
    'input, textarea, [contenteditable] { -webkit-user-select: text !important; user-select: text !important; }',
    // No tap flash
    '* { -webkit-tap-highlight-color: transparent !important; }',
    // No callout menus (copy/share/define)
    '* { -webkit-touch-callout: none !important; }',
    // Smooth fonts
    '* { -webkit-font-smoothing: antialiased; }',
    // No bounce/overscroll
    'body { overscroll-behavior: none !important; overflow-y: scroll; }',
    'html { overscroll-behavior: none !important; }',
    // No zoom on input focus (feels webby)
    'input, textarea, select { font-size: 16px !important; }',
    // Force dark background everywhere — no white flash between pages
    'html, body { background-color: #0A0E1A !important; }',
    // Hide scrollbars
    '::-webkit-scrollbar { display: none !important; }',
    // No text resize
    'body { -webkit-text-size-adjust: none !important; text-size-adjust: none !important; }'
  ].join('\n');
  document.head.appendChild(style);

  // Force dark background on html/body immediately (before CSS loads)
  document.documentElement.style.backgroundColor = '#0A0E1A';
  document.body && (document.body.style.backgroundColor = '#0A0E1A');

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

  function isSignInPage() {
    var p = window.location.pathname;
    return p === '/sign-in' || p === '/signin' || p === '/login';
  }

  function isLandingPage() {
    var p = window.location.pathname;
    return p === '/' || p === '' || p === '/home';
  }

  // ── SPLASH SCREEN ─────────────────────────────────────────────────────
  var SPLASH_IMAGE    = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/03aec7f64_image.png';
  var SPLASH_DURATION = 8000;

  function showSplash() {
    // Show on ANY page if not yet shown this session
    if (sessionStorage.getItem(SPLASH_KEY)) return;

    sessionStorage.setItem(SPLASH_KEY, '1');

    var overlay = document.createElement('div');
    overlay.id = 'tp-splash';
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
          // After splash: route based on auth state
          if (hasAuthToken()) {
            if (window.location.pathname !== '/social') {
              window.location.replace('/social');
            }
          } else {
            // Go to sign-in and show our overlay
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

  // ── CUSTOM SIGN-IN OVERLAY ────────────────────────────────────────────
  // Covers the Base44 white sign-in page entirely with our dark branded UI
  var LOGO_URL = 'https://media.base44.com/images/public/69df5ede5be1d2722b8e2c66/cbc23e8b7_837162d7-468e-4545-95c3-d07bb0aaea7f.png';

  function injectSignInOverlay() {
    if (document.getElementById('tp-signin-overlay')) return;

    // Kill the page background immediately
    document.documentElement.style.background = '#0A0E1A';
    document.body.style.background = '#0A0E1A';

    var overlay = document.createElement('div');
    overlay.id = 'tp-signin-overlay';
    overlay.style.cssText = [
      'position:fixed',
      'inset:0',
      'z-index:9999998',
      'background:#0A0E1A',
      'display:flex',
      'flex-direction:column',
      'align-items:center',
      'justify-content:center',
      'padding:0 32px',
      'font-family:-apple-system,BlinkMacSystemFont,sans-serif',
      'overflow-y:auto',
      '-webkit-overflow-scrolling:touch'
    ].join(';');

    overlay.innerHTML = [
      // Logo
      '<img src="' + LOGO_URL + '" style="width:90px;height:90px;object-fit:contain;margin-bottom:20px;border-radius:50%" />',
      // Title
      '<div style="color:#F5C842;font-size:28px;font-weight:700;margin-bottom:6px;letter-spacing:-0.5px">TradePulse</div>',
      // Subtitle
      '<div style="color:#6B7280;font-size:15px;margin-bottom:40px">The pulse of the market.</div>',

      // Google button
      '<button id="tp-google-btn" style="width:100%;max-width:340px;height:52px;background:#0D1117;border:1.5px solid rgba(255,255,255,0.12);border-radius:14px;color:#fff;font-size:16px;font-weight:500;display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:12px;cursor:pointer;-webkit-appearance:none">',
        '<svg width="20" height="20" viewBox="0 0 48 48"><path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.08 17.74 9.5 24 9.5z"/><path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/><path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/><path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-3.59-13.46-8.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/><path fill="none" d="M0 0h48v48H0z"/></svg>',
        'Continue with Google',
      '</button>',

      // Apple button
      '<button id="tp-apple-btn" style="width:100%;max-width:340px;height:52px;background:#0D1117;border:1.5px solid rgba(255,255,255,0.12);border-radius:14px;color:#fff;font-size:16px;font-weight:500;display:flex;align-items:center;justify-content:center;gap:10px;margin-bottom:28px;cursor:pointer;-webkit-appearance:none">',
        '<svg width="20" height="20" viewBox="0 0 814 1000" fill="white"><path d="M788.1 340.9c-5.8 4.5-108.2 62.2-108.2 190.5 0 148.4 130.3 200.9 134.2 202.2-.6 3.2-20.7 71.9-68.7 141.9-42.8 61.6-87.5 123.1-155.5 123.1s-85.5-39.5-164-39.5c-76 0-103.7 40.8-165.9 40.8s-105-37.5-155.5-127.4C46 790.7 0 663.6 0 541.8c0-194.3 126.4-297.5 250.8-297.5 66.1 0 121.2 43.4 162.7 43.4 39.5 0 101.1-46 176.3-46 28.5 0 130.9 2.6 198.3 99.2zm-234-181.5c31.1-36.9 53.1-88.1 53.1-139.3 0-7.1-.6-14.3-1.9-20.1-50.6 1.9-110.8 33.7-147.1 75.8-28.5 32.4-55.1 83.6-55.1 135.5 0 7.8 1.3 15.6 1.9 18.1 3.2.6 8.4 1.3 13.6 1.3 45.4 0 102.5-30.4 135.5-71.3z"/></svg>',
        'Continue with Apple',
      '</button>',

      // Divider
      '<div style="width:100%;max-width:340px;display:flex;align-items:center;gap:12px;margin-bottom:24px">',
        '<div style="flex:1;height:1px;background:rgba(255,255,255,0.1)"></div>',
        '<div style="color:#6B7280;font-size:13px">or</div>',
        '<div style="flex:1;height:1px;background:rgba(255,255,255,0.1)"></div>',
      '</div>',

      // Email field
      '<div style="width:100%;max-width:340px;margin-bottom:12px">',
        '<input id="tp-email" type="email" placeholder="Email" style="width:100%;height:52px;background:#0D1117;border:1.5px solid rgba(255,255,255,0.12);border-radius:14px;color:#fff;font-size:16px;padding:0 16px;box-sizing:border-box;outline:none;-webkit-appearance:none" />',
      '</div>',

      // Password field
      '<div style="width:100%;max-width:340px;margin-bottom:20px">',
        '<input id="tp-password" type="password" placeholder="Password" style="width:100%;height:52px;background:#0D1117;border:1.5px solid rgba(255,255,255,0.12);border-radius:14px;color:#fff;font-size:16px;padding:0 16px;box-sizing:border-box;outline:none;-webkit-appearance:none" />',
      '</div>',

      // Sign in button
      '<button id="tp-signin-btn" style="width:100%;max-width:340px;height:52px;background:#F5C842;border:none;border-radius:14px;color:#0A0E1A;font-size:17px;font-weight:700;cursor:pointer;-webkit-appearance:none;margin-bottom:16px">Sign In</button>',

      // Forgot password
      '<div style="color:#6B7280;font-size:14px;margin-bottom:12px;cursor:pointer" id="tp-forgot">Forgot password?</div>',

      // Sign up
      '<div style="color:#6B7280;font-size:14px;margin-bottom:32px">Need an account? <span id="tp-signup" style="color:#F5C842;font-weight:600;cursor:pointer">Sign up</span></div>',

      // Footer
      '<div style="color:#374151;font-size:11px;text-align:center;max-width:300px;line-height:1.5">By continuing, you agree to our Terms of Service and Privacy Policy. TradePulse does not provide financial advice.</div>'
    ].join('');

    document.body.appendChild(overlay);

    // Wire up buttons — delegate to the underlying Base44 auth buttons
    function clickBase44Btn(selector) {
      var btn = document.querySelector(selector);
      if (btn) { btn.click(); return true; }
      return false;
    }

    document.getElementById('tp-google-btn').addEventListener('click', function() {
      // Try native bridge first, fall back to Base44 button
      if (window.TradePulse && window.TradePulse.signInWithGoogle) {
        window.TradePulse.signInWithGoogle(function(r) { console.log('google result', r); });
      } else {
        if (!clickBase44Btn('[data-provider="google"] button') &&
            !clickBase44Btn('button[aria-label*="Google"]') &&
            !clickBase44Btn('button:has(svg[data-icon="google"])')) {
          // Find any button containing "Google" text
          var btns = document.querySelectorAll('button');
          for (var i = 0; i < btns.length; i++) {
            if (btns[i].textContent.indexOf('Google') !== -1 && btns[i] !== document.getElementById('tp-google-btn')) {
              btns[i].click(); break;
            }
          }
        }
      }
    });

    document.getElementById('tp-apple-btn').addEventListener('click', function() {
      if (window.TradePulse && window.TradePulse.signInWithApple) {
        window.TradePulse.signInWithApple(function(r) { console.log('apple result', r); });
      } else {
        var btns = document.querySelectorAll('button');
        for (var i = 0; i < btns.length; i++) {
          if (btns[i].textContent.indexOf('Apple') !== -1 && btns[i] !== document.getElementById('tp-apple-btn')) {
            btns[i].click(); break;
          }
        }
      }
    });

    document.getElementById('tp-signin-btn').addEventListener('click', function() {
      var email = document.getElementById('tp-email').value;
      var pass  = document.getElementById('tp-password').value;
      // Fill underlying Base44 inputs and submit
      var inputs = document.querySelectorAll('input[type="email"], input[type="text"]');
      var passInputs = document.querySelectorAll('input[type="password"]');
      if (inputs[0]) { inputs[0].value = email; inputs[0].dispatchEvent(new Event('input', {bubbles:true})); }
      if (passInputs[0]) { passInputs[0].value = pass; passInputs[0].dispatchEvent(new Event('input', {bubbles:true})); }
      setTimeout(function() {
        var submitBtns = document.querySelectorAll('button[type="submit"], form button');
        for (var i = 0; i < submitBtns.length; i++) {
          if (submitBtns[i] !== document.getElementById('tp-signin-btn')) {
            submitBtns[i].click(); break;
          }
        }
      }, 100);
    });

    document.getElementById('tp-forgot').addEventListener('click', function() {
      var links = document.querySelectorAll('a, button');
      for (var i = 0; i < links.length; i++) {
        if (links[i].textContent.indexOf('Forgot') !== -1 || links[i].textContent.indexOf('forgot') !== -1) {
          links[i].click(); break;
        }
      }
    });

    document.getElementById('tp-signup').addEventListener('click', function() {
      window.location.href = '/sign-up';
    });
  }

  // ── INIT ──────────────────────────────────────────────────────────────
  function init() {
    // Always show splash on cold open (any page)
    if (!sessionStorage.getItem(SPLASH_KEY)) {
      showSplash();
    } else if (isSignInPage()) {
      // Splash already done, just show our sign-in overlay
      injectSignInOverlay();
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

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

  var lastPath = window.location.pathname;
  setInterval(function() {
    var cur = window.location.pathname;
    if (cur !== lastPath) {
      lastPath = cur;
      if (cur === '/social' || cur.indexOf('/social') === 0) {
        setTimeout(fetchAndShowPromo, 600);
      }
      // Remove sign-in overlay if user navigated away
      if (cur !== '/sign-in') {
        var ol = document.getElementById('tp-signin-overlay');
        if (ol && ol.parentNode) ol.parentNode.removeChild(ol);
      }
    }
  }, 300);

  // Check promo on load too (in case app opens directly on /social)
  if (window.location.pathname === '/social' || window.location.pathname.indexOf('/social') === 0) {
    setTimeout(fetchAndShowPromo, 800);
  }
  // Also check after any SPA navigation settles
  window.addEventListener('load', function() {
    if (window.location.pathname === '/social' || window.location.pathname.indexOf('/social') === 0) {
      setTimeout(fetchAndShowPromo, 800);
    }
  });

})();
