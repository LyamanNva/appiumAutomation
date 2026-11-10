
package az.mobileqa;

import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.ios.options.XCUITestOptions;
import io.appium.java_client.AppiumBy;

import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;

import org.testng.annotations.BeforeMethod;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.Test;

import java.net.URL;
import java.time.Duration;

import static org.testng.Assert.*;

public class IOSBankingTests {

    private IOSDriver driver;

    @BeforeMethod
    public void setUp() throws Exception {

        XCUITestOptions options = new XCUITestOptions();

        options.setPlatformName("iOS");
        options.setAutomationName("XCUITest");
        options.setDeviceName("iPhone 18 Pro");
        options.setPlatformVersion("27.2");

        options.setUdid(
                "4E9486B3-4E54-4E5B-A4CE-5ECD5EDF58F6"
        );

        options.setBundleId("ozumucun.DemoBank");

        driver = new IOSDriver(
                new URL("http://127.0.0.1:4723"),
                options
        );
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {

        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    public void TC_001_LoginSuccessful() {

        driver.findElement(
                AppiumBy.accessibilityId("customerIdField")
        ).sendKeys("123456");

        driver.findElement(
                AppiumBy.accessibilityId("pinField")
        ).sendKeys("1234");

        driver.findElement(
                AppiumBy.accessibilityId("loginButton")
        ).click();

        WebDriverWait wait = new WebDriverWait(
                driver,
                Duration.ofSeconds(10)
        );

        WebElement balance = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("balanceLabel")
                )
        );

        assertTrue(balance.isDisplayed());

        System.out.println("TC_001 PASSED: Login successful!");
    }
    @Test
    public void TC_002_EmptyPinLoginShouldBePrevented() {

        driver.findElement(AppiumBy.accessibilityId("customerIdField"))
                .sendKeys("123456");

        driver.findElement(AppiumBy.accessibilityId("loginButton"))
                .click();

        boolean pinFieldVisible = driver
                .findElement(AppiumBy.accessibilityId("pinField"))
                .isDisplayed();

        boolean homeScreenVisible = !driver
                .findElements(AppiumBy.accessibilityId("balanceLabel"))
                .isEmpty();

        assertTrue(pinFieldVisible, "PIN field should remain visible");
        assertFalse(homeScreenVisible, "User should not navigate to Home with empty PIN");

        System.out.println("TC_002 PASSED");
    }
    @Test
    public void TC_003_HideAndShowBalance() {

        // Login
        driver.findElement(AppiumBy.accessibilityId("customerIdField"))
                .sendKeys("123456");

        driver.findElement(AppiumBy.accessibilityId("pinField"))
                .sendKeys("1234");

        driver.findElement(AppiumBy.accessibilityId("loginButton"))
                .click();

        // Wait for Home screen
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        WebElement balance = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("balanceLabel")
                )
        );

        // Check initial balance
        assertEquals(balance.getText(), "12450.00 AZN");
        // Hide balance
        driver.findElement(AppiumBy.accessibilityId("balanceVisibilityButton"))
                .click();

        assertEquals(
                driver.findElement(AppiumBy.accessibilityId("balanceLabel")).getText(),
                "••••••••"
        );

        // Show balance again
        driver.findElement(AppiumBy.accessibilityId("balanceVisibilityButton"))
                .click();

        assertEquals(
                driver.findElement(AppiumBy.accessibilityId("balanceLabel")).getText(),
                "12450.00 AZN"
        );

        System.out.println("TC_003 PASSED");
    }
    @Test
    public void TC_004_FreezeCard() {

        // Login
        driver.findElement(AppiumBy.accessibilityId("customerIdField"))
                .sendKeys("123456");

        driver.findElement(AppiumBy.accessibilityId("pinField"))
                .sendKeys("1234");

        driver.findElement(AppiumBy.accessibilityId("loginButton"))
                .click();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
// Cards tab-ına keç
        driver.findElement(AppiumBy.accessibilityId("tabCards"))
                .click();
        // Kartın görünməsini gözlə
        WebElement card = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("bankCard")
                )
        );

        // İlkin status ACTIVE olmalıdır
        assertTrue(card.getText().contains("ACTIVE"),
                "Card should initially be ACTIVE");

        // Freeze düyməsinə bas
        driver.findElement(AppiumBy.accessibilityId("freezeCardButton"))
                .click();

        // Status FROZEN olmalıdır
        wait.until(driver ->
                driver.findElement(AppiumBy.accessibilityId("bankCard"))
                        .getText().contains("FROZEN")
        );

        assertTrue(
                driver.findElement(AppiumBy.accessibilityId("bankCard"))
                        .getText().contains("FROZEN"),
                "Card should be FROZEN"
        );

        System.out.println("TC_004 PASSED");
    }


    @Test
    public void TC_005_TransferAboveBalanceShouldBeRejected() {

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(15));

        // 1. Login
        wait.until(ExpectedConditions.visibilityOfElementLocated(
                AppiumBy.accessibilityId("customerIdField")
        )).sendKeys("123456");

        driver.findElement(AppiumBy.accessibilityId("pinField"))
                .sendKeys("1234");

        driver.findElement(AppiumBy.accessibilityId("loginButton"))
                .click();

        // 2. Home ekranının açılmasını gözlə
        wait.until(ExpectedConditions.visibilityOfElementLocated(
                AppiumBy.accessibilityId("balanceLabel")
        ));

        // 3. Transfer tabına keç
        wait.until(ExpectedConditions.elementToBeClickable(
                AppiumBy.accessibilityId("tabTransfer")
        )).click();

        // Transfer ekranının açılmasını gözlə
        WebElement newTransferButton = wait.until(
                ExpectedConditions.elementToBeClickable(
                        AppiumBy.accessibilityId("newTransferButton")
                )
        );

        // 4. New Transfer düyməsinə bas
        newTransferButton.click();

        // 5. Recipient daxil et
        WebElement recipient = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("recipientField")
                )
        );

        recipient.sendKeys("9876543210123456");

        // 6. Məbləğ daxil et
        WebElement amount = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("transferAmountField")
                )
        );

        amount.click();
        amount.sendKeys("15000");

        // 7. Keyboard-u bağla
        if (driver.isKeyboardShown()) {
            driver.hideKeyboard();
        }

        // Keyboard-u bağla
        driver.hideKeyboard();

// Confirm düyməsinin görünməsini gözlə
        WebElement confirmButton = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("confirmTransferButton")
                )
        );

// Klik et
        wait.until(ExpectedConditions.elementToBeClickable(confirmButton)).click();
        // 9. Transfer formunun açıq qaldığını yoxla
        WebElement recipientAfterTransfer = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        AppiumBy.accessibilityId("recipientField")
                )
        );

        assertTrue(
                recipientAfterTransfer.isDisplayed(),
                "Transfer should be rejected when amount exceeds balance"
        );

        System.out.println("TC_005 PASSED");
    }


}
