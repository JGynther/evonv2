<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { marked } from "marked";
  import { get } from "$lib/fetch";

  let pageInfo: {
    slug: string;
    content: string;
    title: string;
    [key: string]: unknown;
  };

  onMount(async () => {
    pageInfo = await get(`/api/page/${$page.params.slug}`);
    pageInfo.content = marked.parse(pageInfo.content);
  });
</script>

{#if pageInfo}
  <div class="prose prose-invert md:prose-lg">
    {@html pageInfo.content}
  </div>
{/if}
