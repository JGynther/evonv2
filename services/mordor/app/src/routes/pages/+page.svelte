<script lang="ts">
  import { client } from "../clients";
  import { onMount } from "svelte";
  import { PUBLIC_CONTENT_TABLE } from "$env/static/public";

  let data: Record<string, any>[] = [];

  onMount(async () => {
    if (!$client) return;

    const result = await $client.scan({
      TableName: PUBLIC_CONTENT_TABLE,
    });

    data = result.Items || [];
  });
</script>

<div class="flex flex-col space-y-5">
  <a
    href="/pages/create"
    class="bg-indigo-500 hover:bg-indigo-700 transition px-5 py-2 mb-10 rounded text-white text-center"
  >
    Luo uusi sivu
  </a>
  {#each data as item}
    <a
      href={`/pages/${item.slug}`}
      class="flex flex-col border-2 px-5 py-2 rounded"
    >
      <span class="font-semibold">{item.title}</span>
    </a>
  {/each}
</div>
