<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";

  let offerings: Record<string, any>[] = [];
  let config: Record<string, any> = {};

  let submitted = false;
  let loading = false;
  let state: string;

  // FORM VALUES
  let firstname = "";
  let middlenames = "";
  let lastname = "";
  let email = "";
  let birthdate = "";
  let street = "";
  let postalcode = "";
  let city = "";
  let count: number;

  async function handleSubmit() {
    const subscribe = {
      id: $page.params.id,
      email,
      count,
      subscriber: {
        firstName: firstname,
        middleNames: middlenames,
        lastName: lastname,
        birthDate: birthdate,
        address: {
          street,
          postalCode: postalcode,
          city,
        },
      },
    };

    loading = true;

    const result = await fetch("/api/subscribe", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(subscribe),
    });

    submitted = true;
    loading = false;

    state =
      result.status === 200
        ? "Merkintä lähetetty onnistuneesti. Vahvista merkintä sähköpostistasi."
        : "Merkinnän lähettäminen epäonnistui.";
  }

  onMount(async () => {
    const result = await fetch("/api/offerings");
    offerings = await result.json();
    config = offerings.filter((offering) => offering.id === $page.params.id)[0];
    count = config.min;
  });
</script>

{#if config.active}
  <div class="space-y-5 mb-14">
    {#if config.banner}
      <img src={config.banner} alt="Banner" class="mb-10" />
    {/if}
    <h1 class="text-4xl font-serif mb-10">{config.title}</h1>
    <p class="text-white text-opacity-80 whitespace-pre-wrap">
      {config.description}
    </p>
    <div
      class="border border-neutral-700 bg-neutral-800 px-5 py-3 rounded text-white text-opacity-80"
    >
      <h3 class="text-xl mb-2 text-white text-opacity-100">Perustiedot</h3>
      <p>Merkintäaika: {config.start} - {config.end}</p>
      <p>Osakkeen hinta: {config.price} EUR</p>
      <p>Minimimerkintä: {config.min} kpl</p>
    </div>
    <div class="text-white text-opacity-80">
      <p class="mb-4">
        Antiin liittyvät dokumentit. Tutustu näihin erityisellä huolella.
      </p>
      <ul class="space-y-4">
        {#each config.documents as document}
          <li>
            <a
              href={document}
              target="_blank"
              rel="noopener"
              class="border border-neutral-700 bg-neutral-800 hover:bg-neutral-700 transition rounded py-1 px-2 max-w-min"
              >{document.split("/").slice(-1)}</a
            >
          </li>
        {/each}
      </ul>
    </div>
  </div>
{/if}

{#if config.active && !submitted}
  <form
    class="mb-14 space-y-6 max-w-lg"
    on:submit|preventDefault={handleSubmit}
  >
    <div class="space-y-1 mb-6">
      <h3 class="text-2xl font-serif">Merkintälomake</h3>
      <p class="text-white text-opacity-80">
        Tee merkintä täyttämällä oheinen lomake. Täytä lomake huolella ja
        varmista tietojesi oikeellisuus. Lomakkeen lähettämisen jälkeen saat
        sähköpostiisi vahvistuslinkin, jonka kautta vahvistat merkinnän.
      </p>
    </div>
    <p class="text-white text-opacity-60">
      Pakolliset kentät merkitty *-merkillä.
    </p>
    <div class="flex flex-col">
      <label for="firstname" class="text-white text-opacity-80 mb-2"
        >Etunimi *</label
      >
      <input
        id="firstname"
        class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
        required
        bind:value={firstname}
      />
    </div>
    <div class="flex flex-col">
      <label for="temp" class="text-white text-opacity-80 mb-2"
        >Toiset nimet</label
      >
      <input
        id="temp"
        class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
        bind:value={middlenames}
      />
    </div>
    <div class="flex flex-col">
      <label for="temp" class="text-white text-opacity-80 mb-2"
        >Sukunimi *</label
      >
      <input
        id="temp"
        class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
        required
        bind:value={lastname}
      />
    </div>
    <div class="flex flex-col">
      <label for="temp" class="text-white text-opacity-80 mb-2"
        >Sähköposti *</label
      >
      <input
        id="temp"
        type="email"
        class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
        required
        bind:value={email}
      />
    </div>
    <div class="flex flex-col">
      <label for="temp" class="text-white text-opacity-80 mb-2"
        >Syntymäaika *</label
      >
      <input
        id="temp"
        type="date"
        class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
        required
        bind:value={birthdate}
      />
    </div>
    <div class="py-6">
      <div class="flex flex-col">
        <label for="temp" class="text-white text-opacity-80 mb-2"
          >Katuosoite *</label
        >
        <input
          id="temp"
          class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
          required
          bind:value={street}
        />
      </div>
      <div class="flex justify-between mt-3 flex-wrap">
        <div class="flex flex-col">
          <label for="temp" class="text-white text-opacity-80 mb-2"
            >Postinumero *</label
          >
          <input
            id="temp"
            class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
            required
            bind:value={postalcode}
          />
        </div>
        <div class="flex flex-col">
          <label for="temp" class="text-white text-opacity-80 mb-2"
            >Kaupunki *</label
          >
          <input
            id="temp"
            class="border border-neutral-700 rounded bg-neutral-900 outline-none px-3 py-1"
            required
            bind:value={city}
          />
        </div>
      </div>
    </div>
    <div
      class="bg-neutral-800 border border-neutral-700 rounded p-5 flex flex-col"
    >
      <label for="temp" class="mb-2">Osakkeet (kpl) *</label>
      <input
        type="number"
        min={config.min}
        class="border border-neutral-700 rounded bg-neutral-700 outline-none px-3 py-1"
        bind:value={count}
        required
      />
      <p class="mt-2">Yhteensä: {(count * config.price).toFixed(2)} EUR</p>
    </div>
    <div
      class="bg-rose-500 bg-opacity-20 border border-neutral-700 rounded p-5 flex"
    >
      <input id="ack" type="checkbox" class="scale-150 mr-5" required />
      <label for="ack"
        >Vahvistan lukeneeni ja ymmärtäväni ehdot. Ymmärrän, että merkintä on
        sitova. *</label
      >
    </div>
    <button
      type="submit"
      class="bg-neutral-800 hover:bg-neutral-700 transition border border-neutral-700 rounded px-5 py-2 flex-grow"
      >Lähetä merkintä</button
    >
  </form>
{/if}

{#if loading}
  <p>Lähetetään...</p>
{/if}

{#if submitted}
  <p>{state}</p>
{/if}
