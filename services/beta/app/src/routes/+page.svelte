<script lang="ts">
    import { getAllBlogs, type Blog } from "$lib/blog";
    import { onMount } from "svelte";

    let blogs: Blog[] = [];

    onMount(async () => {
        blogs = await getAllBlogs();
        blogs = blogs.sort(
            (a, b) =>
                // Possible performance issues with creating new Date objects?
                new Date(b.createdAt).getTime() -
                new Date(a.createdAt).getTime()
        );
    });
</script>

<div
    class="bg-neutral-800 flex flex-col p-5 divide-y divide-neutral-700 rounded"
>
    {#each blogs as blog}
        <a
            href={`/blog/${blog.id}`}
            class="p-2 bg-neutral-800 hover:bg-neutral-700 transition"
        >
            {new Date(blog.createdAt).toLocaleDateString()} - {blog.title}
        </a>
    {/each}
</div>
