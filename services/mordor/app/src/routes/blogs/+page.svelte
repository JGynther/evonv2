<script lang="ts">
  import { client } from "../clients";
  import { onMount } from "svelte";
  import { PUBLIC_BLOG_TABLE } from "$env/static/public";

  let data: Record<string, any>[] = [];

  onMount(async () => {
    if (!$client) return;

    const result = await $client.scan({
      TableName: PUBLIC_BLOG_TABLE,
    });
    data = result.Items || [];
    data = data.sort((a, b) => +new Date(b.createdAt) - +new Date(a.createdAt));
  });
</script>

<div class="flex flex-col space-y-5">
  <a
    href="/blogs/create"
    class="bg-indigo-500 hover:bg-indigo-700 transition px-5 py-2 mb-10 rounded text-white text-center"
  >
    Luo uusi blogi
  </a>
  {#each data as item}
    <a
      href={`/blogs/${item.id}`}
      class="flex flex-col border-2 px-5 py-2 rounded"
    >
      <span>{new Date(item.createdAt).toLocaleDateString()}</span>
      <span class="font-semibold">{item.title}</span>
    </a>
  {/each}
</div>
