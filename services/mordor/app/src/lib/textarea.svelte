<script lang="ts">
  import { onMount } from "svelte";

  export let content: string;
  export let id: string;
  export let didEdit: boolean | undefined = undefined;
  export let required = false;

  let textarea: HTMLTextAreaElement;

  function resizeOnInput(
    event: Event & { currentTarget: HTMLTextAreaElement }
  ) {
    const { currentTarget } = event;
    currentTarget.style.height = "1";
    currentTarget.style.height = currentTarget.scrollHeight + "px";
  }

  onMount(() => {
    // For some baffling reason this works only if set twice
    textarea.style.height = textarea.scrollHeight + "px";
    textarea.style.height = textarea.scrollHeight + "px";
  });
</script>

<textarea
  {id}
  class="border-2 rounded p-5 my-2 whitespace-pre resize-none overflow-y-hidden"
  bind:this={textarea}
  bind:value={content}
  on:input={resizeOnInput}
  on:focus={() => (didEdit = true)}
  {required}
  spellcheck="false"
/>
