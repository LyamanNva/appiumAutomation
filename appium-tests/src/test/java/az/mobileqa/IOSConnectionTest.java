
package az.mobileqa;

import io.appium.java_client.ios.IOSDriver;
import io.appium.java_client.ios.options.XCUITestOptions;
import org.testng.annotations.Test;

import java.net.URL;

import static org.testng.Assert.assertNotNull;

public class IOSConnectionTest {

    @Test
    public void connectToIPhoneSimulator() throws Exception {

        // 1. iOS cihazının parametrlərini təyin edirik
        XCUITestOptions options = new XCUITestOptions();

        options.setPlatformName("iOS");
        options.setAutomationName("XCUITest");
        options.setDeviceName("iPhone 18 Pro");
        options.setPlatformVersion("27.2");

        options.setUdid(
                "4E9486B3-4E54-4E5B-A4CE-5ECD5EDF58F6"
        );

        // 2. iPhone Settings tətbiqini açırıq
        options.setBundleId("ozumucun.DemoBank");

        // 3. Appium serverinə qoşuluruq
        IOSDriver driver = new IOSDriver(
                new URL("http://127.0.0.1:4723"),
                options
        );

        try {

            // 4. Session yaradıldığını yoxlayırıq
            assertNotNull(driver.getSessionId());

            System.out.println(
                    "iPhone 18 Pro connection successful!"
            );

            System.out.println(
                    "Session ID: " + driver.getSessionId()
            );

        } finally {

            // 5. Test bitdikdən sonra bağlantını bağlayırıq
            driver.quit();
        }
    }
}
