<script lang="ts">
  import { client } from "./clients";
  import { onMount } from "svelte";
  import { PUBLIC_SUBSCRIPTIONS_TABLE } from "$env/static/public";

  // TODO: add better typing
  let data: Record<string, any>[] = [];

  onMount(async () => {
    if (!$client) return;

    const result = await $client.scan({
      TableName: PUBLIC_SUBSCRIPTIONS_TABLE,
    });
    data = result.Items || [];
    data.sort((a, b) => b.confirmedAt - a.confirmedAt);
  });
</script>

<h1>Latest subscriptions</h1>
<div class="border bg-neutral-100 rounded divide-y">
  {#each data as subscribe}
    <div class="flex divide-x">
      <span class="w-1/6 py-1 px-3"
        >{new Date(subscribe?.confirmedAt).toLocaleDateString()}</span
      >
      <span class="w-1/2 py-1 px-3"
        >{subscribe?.subscriber?.firstName}
        {subscribe?.subscriber?.lastName}</span
      >
      <span class="py-1 px-3">{subscribe?.sum}</span>
    </div>
  {/each}
</div>
