<script lang="ts">
    import { onMount } from "svelte";
    import { page } from "$app/stores";
    import { getAuthorById, type Author } from "$lib/blog";

    let author: Author;

    onMount(async () => {
        author = await getAuthorById($page.params.id);
    });
</script>

{#if author}
    <div>{author.name}</div>
    <div>{author.description}</div>
{/if}
