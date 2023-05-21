<script lang="ts">
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { auth } from "../store";

  import {
    getClientInfo,
    authorizeDevice,
    getCredentials,
    checkForLocalCredentials,
  } from "$lib/auth";

  let url: string;
  let state = "Checking client.";

  onMount(async () => {
    const client = await getClientInfo();

    state = "Checking for existing credentials";
    const localCredentials = checkForLocalCredentials();

    if (localCredentials) {
      state = "Redirecting";
      auth.set(localCredentials);
      goto("/", { replaceState: true });
      return;
    }

    state = "Starting authorization flow";
    const authorization = await authorizeDevice(client);
    url = authorization.verificationUriComplete;

    state = "Waiting for authentication";
    const credentials = await getCredentials(client, authorization);

    state = "Redirecting";
    auth.set(credentials);
    goto("/", { replaceState: true });
  });
</script>

<div class="space-y-5">
  <h1 class="text-xl font-bold pb-5">Mordor system authentication</h1>
  <p>{state}</p>

  {#if url}
    <div class="border rounded p-5 bg-neutral-100">
      <p class="font-semibold">Please open this link to authenticate</p>
      <a href={url} target="_blank" class="text-blue-700">{url}</a>
    </div>
  {/if}
</div>
