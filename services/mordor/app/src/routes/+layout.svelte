<script lang="ts">
  import "../global.css";

  import { goto } from "$app/navigation";
  import { onMount } from "svelte";
  import { page } from "$app/stores";

  import { auth } from "./store";
  import { logout } from "$lib/auth";

  $: isAuthenticated = $auth ? true : false;

  onMount(() => {
    if (!isAuthenticated) goto("/login", { replaceState: true });
  });
</script>

<div class="min-h-screen flex flex-col items-center">
  <header class="border-b w-full mb-10 px-10 py-6 flex justify-between">
    <a href="/" class="text-xl font-bold">Mordor</a>
    {#if isAuthenticated}
      <button
        on:click={() => {
          logout();
          auth.set(false);
        }}>Logout</button
      >
    {/if}
  </header>

  <div class="container max-w-screen-md px-5 flex-grow">
    {#if isAuthenticated || $page.route.id === "/login"}
      <slot />
    {/if}
  </div>

  <footer class="border-t w-full px-10 py-6 mt-10">
    For authorized use only. © 2023 Evon Capital Oy Ab
  </footer>
</div>
