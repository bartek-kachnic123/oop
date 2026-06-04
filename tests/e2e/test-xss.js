const { Builder, By } = require('selenium-webdriver');

(async function xssTest() {
  let driver = await new Builder().forBrowser('chrome').build();

  try {
    await driver.get('http://localhost:5173');

    const payload = "<img src=x onerror=alert('XSS')>";

    await driver.findElement(By.id('messageInput')).sendKeys(payload);
    await driver.findElement(By.id('send')).click();

    await driver.sleep(1000);

    let alert = await driver.switchTo().alert();
    console.log("ALERT TEXT:", await alert.getText());
    await alert.accept();

  } finally {
    await driver.quit();
  }
})();

