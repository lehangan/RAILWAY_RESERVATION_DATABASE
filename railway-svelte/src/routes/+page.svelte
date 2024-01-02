<script lang='ts'>
	import SearchInfo from './SearchInfo.svelte';

	// Get data from +page.server.svelte
	export let data;

	let way = "one";
</script>


<div class="fixed w-full bg-cover bg-no-repeat bg-center banner py-52 -z-10">
</div>

<div class="flex flex-col items-center justify-center py-36 space-y-3">
	<h1 class="text-5xl font-bold text-white">Vietnam Railway</h1>
	<h3 class="text-lg font-bold text-white">Search the cheapest fare for you</h3>
</div>

<div class="mx-36 -mt-16">
	<div class="border border-primary px-4 pt-2 pb-4 rounded-md bg-base-100">
	<div role="tablist" class="tabs-bordered space-x-6">
		<input type="radio" bind:group={way} value="one" class="tab" aria-label="One-way"/>
		<input type="radio" bind:group={way} value="return" class="tab" aria-label="Return"/>
		<input type="radio" bind:group={way} value="open" class="tab" aria-label="Open return" />

		<div class="mt-6 !mx-0"><SearchInfo bind:way items={data.stations}/></div>
	</div>
	</div>
</div>








<h1>Welcome to SvelteKit</h1>
<p>Visit <a href="https://kit.svelte.dev">kit.svelte.dev</a> to read the documentation</p>

<style lang='postcss'>
	.tab:is(input:checked) {
    @apply border-primary text-primary font-bold;
	}

	.banner {
		background-image: url($lib/assets/train-banner.jpg);
	}
</style>
