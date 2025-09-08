(function() {
  'use strict';

  if (document.location.href.includes('www.youtube.com')) {
    console.log('injecting css to youtube...')
    GM_addStyle(`
      .ytp-gradient-bottom {
        display: none;
      }
    `);
  }
})();
