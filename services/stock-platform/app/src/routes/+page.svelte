<script lang="ts">
  import { onMount } from "svelte";

  let offerings: Record<string, any>[] = [];

  onMount(async () => {
    const result = await fetch("/api/offerings");
    offerings = await result.json();
    offerings = offerings.filter((offering) => offering.active === true);
  });
</script>

<h1 class="text-4xl font-serif mb-10">Aktiiviset osakeannit</h1>
<ul>
  {#each offerings as offering}
    <li>
      <a
        href={`/anti/${offering.id}`}
        class="bg-neutral-800 border border-neutral-700 rounded px-4 py-2"
        >{offering.title}</a
      >
    </li>
  {/each}
</ul>
