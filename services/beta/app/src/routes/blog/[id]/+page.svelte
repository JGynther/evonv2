<script lang="ts">
    import { onMount } from "svelte";
    import { page } from "$app/stores";
    import { marked } from "marked";
    import {
        getBlogById,
        batchGetAuthor,
        type Blog,
        type Author,
    } from "$lib/blog";

    let blog: Blog, authors: Author[];

    onMount(async () => {
        blog = await getBlogById($page.params.id);
        blog.content = marked.parse(blog.content);
        authors = await batchGetAuthor(blog.authors);
    });
</script>

{#if blog}
    <article class="prose prose-invert md:prose-lg">
        <h4>{new Date(blog.createdAt).toLocaleDateString()}</h4>
        <h1>{blog.title}</h1>
        {#if authors}
            <div class="bg-neutral-800 px-5 py-3 space-y-3 text-sm">
                {#each authors as author}
                    <div>
                        {author.name}
                        <br />
                        {author.description}
                    </div>
                {/each}
            </div>
        {/if}
        {@html blog.content}
    </article>
{/if}
