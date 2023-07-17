<script lang="ts">
    import { getAllBlogs } from "$lib/blog";
    import { onMount } from "svelte";

    type Blog = {
        content: string;
        title: string;
        createdAt: string;
        authors: string[];
        id: string;
    };

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
