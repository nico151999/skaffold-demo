<script lang="ts">
	import { writable } from "svelte/store";
	import type { PageData } from "./$types";
	import { onMount } from "svelte";

	export let data: PageData;

    const name = writable('');
    let message: string|undefined;

    onMount(() => {
        name.subscribe(async (name) => {
            if (name) {
                const res = await fetch(`${data.baseURL}${data.basePath}`, {
                    method: 'POST',
                    body: name
                });
                message = await res.text();
            }
        });
    });
</script>

<h1>Welcome to Skaffold Demo</h1>
<input placeholder="Type your name" bind:value={$name} />

{#if message}
    The server greets you with "{message}"
{:else}
    The server has not greeted you yet...
{/if}
