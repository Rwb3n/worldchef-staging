// @ts-nocheck
import { ingredientHash } from "./index.ts";
import { assertEquals } from "https://deno.land/std/assert/mod.ts";

Deno.test("ingredientHash canonicalises units to grams", async () => {
  const { hash: h1 } = await ingredientHash("Chicken Breast", 0.2, "kg");
  const { hash: h2 } = await ingredientHash("chicken breast", 200, "g");
  assertEquals(h1, h2);
});

Deno.test("ingredientHash canonicalises ounces", async () => {
  const { hash: h1 } = await ingredientHash("Olive Oil", 1, "oz");
  const { hash: h2 } = await ingredientHash("olive oil", 28.3495, "g");
  assertEquals(h1, h2);
}); 