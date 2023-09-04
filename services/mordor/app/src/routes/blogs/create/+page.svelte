<script lang="ts">
  import { client, Audit } from "../../clients";
  import { PUBLIC_BLOG_TABLE } from "$env/static/public";
  import Textarea from "$lib/textarea.svelte";
  import { goto } from "$app/navigation";

  let id: string;
  let title: string;
  let authors: string;
  let content: string;

  const today = new Date();
  const createdAt = new Date(
    today.getTime() - today.getTimezoneOffset() * 60000
  )
    .toISOString()
    .slice(0, 10);

  async function create() {
    if (!$client) return;

    const result = await $client.put({
      Item: {
        id: id,
        authors: authors.split(",").map((a) => a.trim()),
        title: title,
        createdAt: createdAt,
        content: content,
      },
      TableName: PUBLIC_BLOG_TABLE,
      ConditionExpression: "attribute_not_exists(id)",
    });

    $Audit?.event({
      eventName: "createBlog",
      resource: { TableName: PUBLIC_BLOG_TABLE, BlogID: id },
    });

    goto(`/blogs/${id}`);
  }
</script>

<form class="space-y-5" on:submit={create}>
  <div class="flex flex-col">
    <label for="createdAt">Päivämäärä </label>
    <span class="opacity-80 text-sm">Ohje: muodossa YYYY-MM-DD.</span>
    <input
      id="createdAt"
      value={createdAt}
      required
      class="border-2 rounded px-3 py-1 my-2 disabled:opacity-60"
    />
  </div>

  <div class="flex flex-col">
    <label for="id">Slug/ID</label>
    <span class="opacity-80 text-sm">
      Ohje: osoiteriville (esim. evon.fi/blog/ESIMERKKI) tuleva uniikki
      tunniste. Tätä ei voi muuttaa myöhemmin.
    </span>
    <input
      id="id"
      bind:value={id}
      required
      class="border-2 rounded px-3 py-1 my-2 disabled:opacity-60"
    />
  </div>

  <div class="flex flex-col">
    <label for="title">Otsikko</label>
    <input
      id="title"
      bind:value={title}
      required
      class="border-2 rounded px-3 py-1 my-2 disabled:opacity-60"
    />
  </div>

  <div class="flex flex-col">
    <label for="authors">Tekijät</label>
    <span class="opacity-80 text-sm">
      Ohje: pilkulla erotettu lista AuthorID:tä.
    </span>
    <input
      id="authors"
      bind:value={authors}
      required
      class="border-2 rounded px-3 py-1 my-2 disabled:opacity-60"
    />
  </div>

  <div class="flex flex-col">
    <label for="content">Sisältö</label>
    <span class="opacity-80 text-sm">
      Ohje: <a href="https://commonmark.org/help/" class="underline">
        CommonMark
      </a>
      -markdown tyylillä formatoitua tekstiä.
    </span>
    <Textarea id="content" bind:content required />
  </div>

  <button
    type="submit"
    class="w-full bg-indigo-500 hover:bg-indigo-700 disabled:opacity-60 transition px-3 py-2 rounded text-white"
  >
    Tallenna
  </button>
</form>
