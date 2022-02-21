import { chromium, Page } from '@playwright/test';
import 'dotenv/config';
import { log } from 'npmlog';
import * as fs from 'fs';

const vpnUrl = process.env.VPN_URL;
let email = process.env.VPN_USER;
const password = process.env.VPN_PASSWORD;
const cookieFile = process.env.COOKIE_FILE;

const emailSelector = 'input[type="email"]';
const passwordSelector = 'input[type="password"]';

const timeout = 3_000;

const launchOptions = {
  headless: true,
  args: [
    '--incognito'
  ],
  executablePath: '/usr/bin/chromium-browser'
};

let mfaFound = false;

(async () => {
  const browser = await chromium.launch({
    ...launchOptions,
  });
  const context = await browser.newContext();
  let page = await context.newPage();

  await navigateToVpnUrl(page);
  let authenticated = false;

  try {
    while (!authenticated) {
      await Promise.all([
        await fillEmail(page),
        await fillPassword(page),
        await fillMFA(page),
        await usePasswordInstead(page),
        await fillSignedIn(page),
        await fillWorkOrSchoolAccount(page),
        await checkRequestDenied(page),
      ]);

      const cookies = await context.cookies();
      const dsidCookie = cookies.find((cookie) => cookie.name === 'DSID');
      if (dsidCookie) {
        authenticated = true;
        fs.writeFileSync(cookieFile, dsidCookie.value, 'utf-8');
        break;
      }
      log('info', '', 'DSID cookie not found, starting new iteration');
      //await page.screenshot({ path: '/mnt/screen.png', fullPage: true });
    }
  } catch (e) {
    log('error', '', e);
  } finally {
    await context.close();
    await browser.close();
  }
})();

async function checkRequestDenied(page: Page) {
  try {
    await page.waitForSelector('div:has-text("Request denied")', { timeout });
    log('error', '', 'Request denied');
    throw 'Request denied';
  } catch (e) {
    if (e === 'Request denied') {
      throw e;
    }
  }
}

async function fillWorkOrSchoolAccount(page: Page) {
  try {
    await page.waitForSelector('div:has-text("Work or school account")', {
      timeout,
    });
    log('info', '', 'Work or school account - found');
    await page.click('xpath=//div>small[0]');
  } catch (e) {}
}

async function fillSignedIn(page: Page) {
  try {
    if (await page.$('div:has-text("Stay signed in?")')) {
      log('info', '', 'Stay signed in - found');
      await page.press('input[type="submit"]', 'Enter');
    }
  } catch (e) {}
}

async function usePasswordInstead(page: Page) {
  try {
    await page.waitForSelector('a:text("Use your password instead")")', {
      timeout,
    });
    if (!mfaFound) {
      log('info', '', 'Use password instead - found');
      await (await page.$('a:text("Use your password instead")')).click();
    }
  } catch (e) {}
}

async function fillMFA(page: Page) {
  try {
    if (await page.$('div:has-text("Approve sign in")')) {
      mfaFound = true;
      const code = await (
        await page.$('#idRichContext_DisplaySign')
      )?.innerText();
      console.log('MFA code: ', code);
      log('info', '', 'Waiting until approved MFA');
      await page.waitForNavigation({ timeout: 30_000 });
    }
  } catch (e) {
    mfaFound = false;
  }
}

async function fillEmail(page: Page) {
  try {
    await page.waitForSelector(emailSelector, { timeout });
    log('info', '', 'Email field found');
    await (await page.$(emailSelector))?.fill(email);
    await (await page.$(emailSelector))?.press('Enter');
  } catch (e) {}
}

async function fillPassword(page: Page) {
  try {
    await page.waitForSelector(passwordSelector, { timeout });
    log('info', '', 'Password field found');
    await (await page.$(passwordSelector))?.fill(password);
    await (await page.$(passwordSelector))?.press('Enter');
  } catch (e) {}
}

async function navigateToVpnUrl(page: Page) {
  await page.goto(vpnUrl);
}
