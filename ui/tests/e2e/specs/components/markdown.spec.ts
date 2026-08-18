import { expect, test } from "@playwright/test";
import { TEST_APP_NAME, TEST_APP_SEARCH } from "../constants";

test.describe("Markdown Rendering", () => {
  test.beforeEach(async ({ page }) => {
    const responsePromise = page.waitForResponse((response) => response.url().includes("forge-config.json"));
    await page.goto("./apps");
    await responsePromise;
  });

  test("markdown links open in a new tab without triggering parent card click", async ({ page, context }) => {
    const searchBar = page.getByTestId("main-search-bar");
    await searchBar.fill(TEST_APP_SEARCH);

    const testApp = page.locator(`[data-testid="app-result"]:has([data-app-name="${TEST_APP_NAME}"])`).first();
    await expect(testApp).toBeVisible();

    // Click the app card to go to the details page
    await testApp.click();
    await expect(page).toHaveURL(new RegExp(`.*app\\/${TEST_APP_NAME}`));

    const appUrl = page.url();

    const externalLink = page.locator(".markdown-content a:has-text(\"project documentation\")").first();
    await expect(externalLink).toBeVisible();

    await expect(externalLink).toHaveAttribute("target", "_blank");

    const [newPage] = await Promise.all([
      context.waitForEvent("page"),
      externalLink.click(),
    ]);

    await newPage.waitForLoadState();

    expect(newPage.url()).not.toBe(appUrl);
    expect(page.url()).toBe(appUrl);

    await newPage.close();

    const internalLink = page.locator(".markdown-content a:has-text(\"enter the Nix shell\")").first();
    await expect(internalLink).toBeVisible();

    await expect(internalLink).not.toHaveAttribute("target", "_blank");

    await internalLink.click();

    const expectedUrl = new RegExp(`.*app\\/${TEST_APP_NAME}#run-shell`);
    await expect(page).toHaveURL(expectedUrl);
  });
});
