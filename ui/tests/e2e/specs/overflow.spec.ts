import { expect, test } from "@playwright/test";

test.describe("Text wrapping", () => {
  test.use({ viewport: { width: 425, height: 570 } });

  test("find overflowing elements on mobile", async ({ page }) => {
    await page.goto("/recipe/options?p=apps&p=pkgs");
    await page.waitForSelector(".min-vh-100");
    await page.waitForSelector("[data-testid=\"option-result\"]");
    await page.waitForTimeout(3000); // Wait a bit for rendering

    // Inject a script to find all elements wider than the viewport
    const overflowingElements = await page.evaluate(() => {
      const docWidth = document.documentElement.clientWidth;
      const elements = document.querySelectorAll("*");
      const overflowing = [];

      for (let i = 0; i < elements.length; i++) {
        const el = elements[i];
        const rect = el.getBoundingClientRect();

        // If element's right edge is beyond docWidth (with a small margin)
        // or its width is strictly greater than docWidth
        if (rect.width > docWidth || rect.right > docWidth + 1) {
          // Ignore script, style tags etc
          if (["SCRIPT", "STYLE", "HTML", "BODY", "HEAD"].includes(el.tagName)) continue;

          let clone = el.cloneNode(false);
          overflowing.push({
            tagName: el.tagName,
            className: el.className,
            id: el.id,
            width: rect.width,
            right: rect.right,
            docWidth: docWidth,
            html: clone.outerHTML,
            text: el.textContent.substring(0, 100).trim(),
          });
        }
      }
      return overflowing;
    });

    console.log(`Found ${overflowingElements.length} overflowing elements:`);
    for (const info of overflowingElements) {
      console.log(JSON.stringify(info, null, 2));
    }

    expect(overflowingElements.length).toBe(0);
  });
});
