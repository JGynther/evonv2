<script lang="ts">
  import { client, Audit } from "../../clients";
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { PUBLIC_CONTENT_TABLE } from "$env/static/public";
  import Textarea from "$lib/textarea.svelte";

  let data: Record<string, any>;
  let didEdit = false;

  let title: string;
  let content: string;

  async function save() {
    if (!$client) return;

    const result = await $client.update({
      Key: { slug: $page.params.slug },
      TableName: PUBLIC_CONTENT_TABLE,
      UpdateExpression: "SET title = :title, content = :content",
      ExpressionAttributeValues: {
        ":title": title,
        ":content": content,
      },
    });

    $Audit?.event({
      eventName: "updatePage",
      resource: { TableName: PUBLIC_CONTENT_TABLE, PageID: $page.params.slug },
    });

    didEdit = false;
  }

  onMount(async () => {
    if (!$client) return;

    const result = await $client.get({
      Key: { slug: $page.params.slug },
      TableName: PUBLIC_CONTENT_TABLE,
    });

    data = result.Item || {};

    title = data.title;
    content = data.content;
  });
</script>

{#if data}
  <div class="space-y-5">
    {#if didEdit}
      <p class="text-red-600 text-2xl font-bold tracking-wider">
        EI TALLENNETTU!
      </p>
    {/if}

    <div>
      <p>Slug/ID: {data.slug}</p>
    </div>

    <div class="flex flex-col">
      <label for="title">Otsikko</label>
      <input
        id="title"
        bind:value={title}
        on:focus={() => (didEdit = true)}
        class="border-2 rounded px-3 py-1 my-2 disabled:opacity-60"
      />
    </div>

    <div class="flex flex-col">
      <label for="content">Sisältö</label>
      <span class="opacity-80 text-sm">
        Ohje: <a href="https://commonmark.org/help/" class="underline"
          >CommonMark</a
        > -markdown tyylillä formatoitua tekstiä
      </span>
      <Textarea id="content" bind:content bind:didEdit />
    </div>

    {#if didEdit}
      <p class="text-red-600 text-2xl font-bold tracking-wider">
        EI TALLENNETTU!
      </p>
    {/if}

    <div>
      <button
        disabled={!didEdit}
        on:click={save}
        class="w-full bg-indigo-500 enabled:hover:bg-indigo-700 disabled:opacity-60 transition px-3 py-2 mt-5 rounded text-white"
      >
        Tallenna
      </button>
    </div>
  </div>
{/if}
