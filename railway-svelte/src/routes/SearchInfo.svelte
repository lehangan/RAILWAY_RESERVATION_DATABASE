<script>
	import DateGet from './DatePicker.svelte';
	import Select from 'svelte-select';

	export let way = 0;

	let departDate = new Date();
	let returnDate = new Date();

	let departStation;
	let returnStation;


	export let items = ['A', 'B', 'C'];
</script>

<div class="grid lg:grid-cols-5 grid-cols-3 gap-4">
	<div class="lg:col-span-2 col-span-3 flex gap-4">
		<Select {items} class="themed-select !border-gray-300" 
			placeholder="From" 
			bind:value={departStation}/>
		<Select {items} class="themed-select !border-gray-300" 
			placeholder="To"
			bind:value={returnStation}/>
	</div>
	<DateGet bind:inputDate={departDate} />
	{#if way == "one"}
		<button class="btn btn-outline justify-start" on:click={() => way = "return"}>+ Add return</button>
	{:else if way == "return"}
		<DateGet bind:inputDate={returnDate} />
	{:else}
		<div class="input input-bordered pl-4 pt-3">Open return</div>
	{/if}
	
	<button class="btn btn-secondary">Search</button>
</div>


<style lang='postcss'>
	:global(.themed-select) {
		--background: oklch(var(--b1));

		--item-hover-bg: oklch(var(--p) / .7);
		--item-hover-color: oklch(var(--pc));

		--item-is-active-bg: oklch(var(--p));
		--item-is-active-color: oklch(var(--pc));

		--list-background: oklch(var(--b1));
		--item-color: oklch(var(--bc));
	}

</style>