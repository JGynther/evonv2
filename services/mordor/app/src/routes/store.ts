import { writable } from "svelte/store";
import { browser } from "$app/environment";
import { checkForLocalCredentials } from "$lib/auth";

export const auth = writable((browser && checkForLocalCredentials()) || false);
