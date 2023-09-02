<script lang="ts">
  import "../global.css";

  import { goto } from "$app/navigation";
  import { onMount } from "svelte";
  import { page } from "$app/stores";

  import { auth } from "./store";
  import { logout } from "$lib/auth";

  $: isAuthenticated = $auth ? true : false;

  function createBreadcrumbs(parts: string[]) {
    let crumbs = parts[1] ? ["/", "/" + parts[1]] : ["/"];

    for (let i = 2; i < parts.length; ++i) {
      crumbs.push(crumbs[i - 1] + "/" + parts[i]);
    }

    return crumbs;
  }

  let crumbs: string[] = [];
  $: crumbs = createBreadcrumbs($page.url.pathname.split("/"));

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

  <div class="w-full px-10 mb-10 opacity-80 tracking-wider">
    {#each crumbs as crumb}
      <a href={crumb}>
        {crumb} >
      </a>
    {/each}
  </div>

  <div class="container max-w-screen-md px-5 flex-grow">
    {#if isAuthenticated || $page.route.id === "/login"}
      <slot />
    {/if}
  </div>

  <footer class="border-t w-full px-10 py-6 mt-10">
    For authorized use only. © 2023 Evon Capital Oy Ab
  </footer>
</div>
