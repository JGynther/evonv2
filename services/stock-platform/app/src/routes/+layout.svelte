<script>
  import "../global.css";
</script>

<div class="bg-neutral-900 text-white min-h-screen flex flex-col items-center">
  <header class="border-b border-neutral-700 w-full mb-10 px-10 py-6">
    <a href="/" class="text-xl font-serif tracking-widest uppercase">
      Osakeannit — Evon Capital
    </a>
  </header>
  <div class="container max-w-screen-md px-5 flex-grow">
    <slot />
  </div>
  <footer
    class="border-t border-neutral-700 w-full px-10 py-6 text-white text-opacity-80 mt-10"
  >
    © 2023 Evon Capital Oy Ab
  </footer>
</div>
