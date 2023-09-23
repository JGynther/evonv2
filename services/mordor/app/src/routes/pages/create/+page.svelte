<script lang="ts">
  import { client, Audit } from "../../clients";
  import { PUBLIC_CONTENT_TABLE } from "$env/static/public";
  import Textarea from "$lib/textarea.svelte";
  import { goto } from "$app/navigation";

  let slug: string;
  let title: string;
  let content: string;

  async function create() {
    if (!$client) return;

    const result = await $client.put({
      Item: {
        slug: slug,
        title: title,
        content: content,
      },
      TableName: PUBLIC_CONTENT_TABLE,
      ConditionExpression: "attribute_not_exists(slug)",
    });

    $Audit?.event({
      eventName: "createPage",
      resource: { TableName: PUBLIC_CONTENT_TABLE, PageID: slug },
    });

    goto(`/pages/${slug}`);
  }
</script>

<form class="space-y-5" on:submit={create}>
  <div class="flex flex-col">
    <label for="id">Slug/ID</label>
    <span class="opacity-80 text-sm">
      Ohje: osoiteriville (esim. evon.fi/ESIMERKKI) tuleva uniikki tunniste.
      Tätä ei voi muuttaa myöhemmin.
    </span>
    <input
      id="id"
      bind:value={slug}
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
