<script lang="ts">
  import { client } from "./clients";
  import { onMount } from "svelte";
  import { PUBLIC_SUBSCRIPTIONS_TABLE } from "$env/static/public";

  // TODO: add better typing
  let data: Record<string, any>[] = [];
  let sum: number;

  onMount(async () => {
    if (!$client) return;

    const result = await $client.scan({
      TableName: PUBLIC_SUBSCRIPTIONS_TABLE,
    });
    data = result.Items || [];
    data = data.filter((item) => item.state === "confirmed");
    data.sort((a, b) => b.confirmedAt - a.confirmedAt);
    sum = data.map((item) => parseFloat(item.sum)).reduce((a, b) => a + b);
  });
</script>

<h1>Latest subscriptions</h1>
<div class="border bg-neutral-100 rounded divide-y">
  <div class="flex divide-x bg-neutral-200">
    <span class="w-1/6 py-1 px-3">Päivämäärä</span>
    <span class="w-1/2 py-1 px-3">Nimi</span>
    <span class="py-1 px-3">
      {sum}
    </span>
  </div>
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
