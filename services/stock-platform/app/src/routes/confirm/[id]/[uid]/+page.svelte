<script lang="ts">
  import { page } from "$app/stores";
  const { id, uid } = $page.params;
  const [email, otp] = uid.split("::");

  let state: string;

  async function verify() {
    const result = await fetch("/api/confirm", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        id,
        email,
        otp,
      }),
    });

    state =
      result.status === 200
        ? "Merkintäsi on vahvistettu onnistuneesti."
        : "Merkintäsi vahvistamisessa tapahtui virhe.";
  }
</script>

{#if !state}
  <p>Sähköposti: {email}</p>
  <p>Vahvistustunnus: {otp}</p>
  <button
    on:click={verify}
    class="bg-neutral-800 border border-neutral-700 rounded px-4 py-2 mt-5"
    >Vahvista osakeannin merkintä</button
  >
{/if}

{#if state}
  <p>{state}</p>
{/if}
