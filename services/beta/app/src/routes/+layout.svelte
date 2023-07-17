<script lang="ts">
    import "../global.css";
</script>

<div class="bg-neutral-900 min-h-screen text-white flex flex-col">
    <header
        class="sticky top-0 z-10 mb-12 bg-neutral-900 border-b border-neutral-700"
    >
        <div
            class="py-5 px-14 font-serif tracking-widest text-xl flex items-center"
        >
            <img
                src="logo.webp"
                alt="Evon Capital logo"
                width={60}
                class="mr-4"
            />
            EVON CAPITAL
        </div>
    </header>

    <div class="flex-grow mx-auto px-5">
        <slot />
    </div>

    <footer class="mt-12 py-5 px-14 border-t border-neutral-700">
        © {new Date().getFullYear()} Evon Capital Oy Ab
    </footer>
</div>
