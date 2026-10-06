const puppeteer = require('puppeteer-core');
(async () => {
  const browser = await puppeteer.launch({
    executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',
    headless: 'new',
  });
  const url = 'https://tnclubmanagement.github.io/tnclub-inspiring-story/';

  const sizes = [
    { name: 'desktop', w: 1440, h: 1600 },
    { name: 'tablet', w: 768, h: 1400 },
    { name: 'mobile', w: 390, h: 1600 },
  ];
  for (const s of sizes) {
    const page = await browser.newPage();
    await page.setViewport({ width: s.w, height: s.h });
    await page.goto(url, { waitUntil: 'networkidle0' });
    await new Promise(r => setTimeout(r, 1500));
    await page.screenshot({ path: `/tmp/live-${s.name}.png`, fullPage: true });
    await page.close();
  }

  // Mobile nav open
  const mpage = await browser.newPage();
  await mpage.setViewport({ width: 390, height: 900 });
  await mpage.goto(url, { waitUntil: 'networkidle0' });
  await mpage.click('.navbar-toggler');
  await new Promise(r => setTimeout(r, 600));
  await mpage.screenshot({ path: '/tmp/live-mobile-nav-open.png' });

  await browser.close();
})();
