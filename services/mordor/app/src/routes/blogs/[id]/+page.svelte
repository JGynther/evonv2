<script lang="ts">
  import { client } from "../../clients";
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { PUBLIC_BLOG_TABLE } from "$env/static/public";
  import Textarea from "$lib/textarea.svelte";

  let data: Record<string, any>;
  let didEdit = false;

  let title: string;
  let authors: string;
  let content: string;

  async function save() {
    if (!$client) return;

    const result = await $client.update({
      Key: { id: $page.params.id },
      TableName: PUBLIC_BLOG_TABLE,
      UpdateExpression:
        "SET title = :title, authors = :authors, content = :content",
      ExpressionAttributeValues: {
        ":title": title,
        ":authors": authors.split(",").map((a) => a.trim()),
        ":content": content,
      },
    });

    if (result.$metadata.httpStatusCode !== 200)
      return alert("Tallentaminen ei onnistu"); // TODO: better error messaging

    didEdit = false;
  }

  onMount(async () => {
    if (!$client) return;

    const result = await $client.get({
      Key: { id: $page.params.id },
      TableName: PUBLIC_BLOG_TABLE,
    });

    data = result.Item || {};

    title = data.title;
    authors = data.authors.join(", ");
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
      <p>Slug/ID: {data.id}</p>
      <p>Julkaistu: {new Date(data.createdAt).toLocaleDateString()}</p>
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
      <label for="authors">Tekijät</label>
      <span class="opacity-80 text-sm"
        >Ohje: pilkulla erotettu lista AuthorID:tä</span
      >
      <input
        id="authors"
        bind:value={authors}
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
      <Textarea id="content" {content} {didEdit} />
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
