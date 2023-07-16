<script lang="ts">
    import { getAllBlogs } from "$lib/blog";
    import { onMount } from "svelte";

    let blogs = [];

    onMount(async () => {
        blogs = await getAllBlogs();
    });
</script>

{#each blogs as blog}
    <div>
        <h2>{blog.title}</h2>
        <p>{blog.content.slice(0, 100)}</p>
    </div>
{/each}
