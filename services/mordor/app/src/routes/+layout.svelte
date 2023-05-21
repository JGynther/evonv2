<script>
  import "../global.css";
</script>

<div class="min-h-screen flex flex-col items-center">
  <header class="border-b w-full mb-10 px-10 py-6">
    <a href="/" class="text-xl font-bold">Mordor</a>
  </header>

  <div class="container max-w-screen-md px-5 flex-grow">
    <slot />
  </div>

  <footer class="border-t w-full px-10 py-6">
    For authorized use only. © 2023 Evon Capital Oy Ab
  </footer>
</div>
