import { expect, test } from "@playwright/test";
import { TEST_PKG_SEARCH } from "../constants";

test.describe("Markdown Rendering", () => {
  test.beforeEach(async ({ page }) => {
    const responsePromise = page.waitForResponse((response) => response.url().includes("forge-config.json"));
    await page.goto("./pkgs");
    await responsePromise;
  });

  test("markdown links open in a new tab without triggering parent card click", async ({ page, context }) => {
    const searchBar = page.getByTestId("main-search-bar");
    await searchBar.fill(TEST_PKG_SEARCH);

    const testPackage = page.locator(`[data-testid="pkg-result"][id="mock-test-pkg"]`);
    await expect(testPackage).toBeVisible();

    const pkgUrl = page.url();

    // Look for the markdown link inside the package card
    const markdownLink = testPackage.locator(".markdown-content a").first();
    await expect(markdownLink).toBeVisible();

    // The link should have target="_blank"
    await expect(markdownLink).toHaveAttribute("target", "_blank");

    // Click the link and wait for the new page event
    const [newPage] = await Promise.all([
      context.waitForEvent("page"),
      markdownLink.click(),
    ]);

    await newPage.waitForLoadState();

    // Verify the new page URL is correct (example.com from the generator)
    expect(newPage.url()).toContain("example.com");

    // Verify that clicking the link did NOT trigger the package card's routing
    // If bubbling was not prevented, the URL would change to /pkgs#mock-test-pkg
    expect(page.url()).toBe(pkgUrl);

    await newPage.close();
  });
});
