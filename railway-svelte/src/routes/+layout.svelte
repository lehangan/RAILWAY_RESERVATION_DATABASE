<script>
	import "../app.css";
	import Logo from '$lib/logo.svg?component';


</script>



<div class="px-24 pt-4 fixed flex justify-between navbar font-bold text-black">
	<div class="invert">
		<a class="btn btn-ghost btn-lg" href="/"><Logo  width="12rem" height="4rem"/></a>
	</div>

	<div>
		<ul class="menu menu-horizontal px-1 visible-child space-x-4">
			<li><a>Browse all</a></li>
			<li><a>Help</a></li>
			<li><a>About</a></li>
		</ul>
		<a class="btn btn-sm px-8 ml-4 btn-primary">Sign in</a>
	</div>
</div>

<slot />

<a class="btn btn-sm btn-primary invert">Sign in</a>

<style lang="postcss">
	.visible-child a {
		@apply invert;
	}

</style>