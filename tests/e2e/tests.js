const { Builder, By, until } = require('selenium-webdriver');

(async function runTests() {
  let driver = await new Builder().forBrowser('chrome').build();

  try {
    await driver.get('http://localhost:5173');

    await driver.findElement(By.id('submit')).click();

    let emailRequired = await driver.wait(
      until.elementLocated(By.xpath("//*[contains(text(),'Email is required')]")),
      2000
    );

    console.log(await emailRequired.getText());

    await driver.findElement(By.id('email')).sendKeys('bademail');
    await driver.findElement(By.id('password')).sendKeys('123456');
    await driver.findElement(By.id('submit')).click();

    let invalidEmail = await driver.wait(
      until.elementLocated(By.xpath("//*[contains(text(),'Invalid email format')]")),
      2000
    );

    console.log(await invalidEmail.getText());

  } finally {
    await driver.quit();
  }
})();

