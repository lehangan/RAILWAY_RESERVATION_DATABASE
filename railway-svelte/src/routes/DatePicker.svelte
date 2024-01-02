<script>
	import { DateInput } from 'date-picker-svelte';

	export let inputDate = new Date();
	const today = new Date();
	const maxDate = new Date();

	maxDate.setMonth(maxDate.getMonth() + 6);	// Max is 6 months later
</script>

<!-- https://date-picker-svelte.kasper.space/docs -->
<div class="edit-input">
	<DateInput bind:value={inputDate} min={today} max={maxDate}
		format="dd/MM/yy HH:mm"
		timePrecision="minute"
		browseWithoutSelecting/>
</div>

<style lang='postcss'>
	:global(.edit-input input) {
		@apply input !w-full !rounded-md !pl-4;
	}
	:global(.edit-input) {
		--date-picker-foreground: oklch(var(--bc));
		--date-picker-background: oklch(var(--b1));
		--date-picker-highlight-border: oklch(var(--p));
		--date-picker-highlight-shadow: oklch(var(--p) / .1);
/*		--date-picker-selected-color: oklch(var(--p));*/
		--date-picker-selected-background: oklch(var(--p) / .2);	
	}
</style>