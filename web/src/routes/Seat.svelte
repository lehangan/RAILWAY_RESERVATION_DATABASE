<script>
// @ts-nocheck

    import { UIstate } from "../store.ts";
    import Layout from "./+layout.svelte";

    /**
     * @type {any[]}
     */
    let Seats= [];
    
    // Add rooms dynamically
    for (let i = 1; i <= 60; i++) {
        Seats.push({ state: "Empty"});
    }
    let state = 0;
</script>
{#if $UIstate == 0}
<Layout/>
{:else}
<div>
    <div>
        <button class = "btn btn-active btn-secondary" on:click={() => $UIstate = 0}> Back </button>
    </div>
    
    

<div >
    <div>
        <div class="grid grid-cols-10 gap-2 rounded-box  p-4 border border-primary bg-base-content" >
            {#each Seats as seat}
                <div>
                    <!-- <button on:click={() => EnterRoom(roomNumber.RoomID)} class=" font-semibold  btn-outline border-4  border-base-100 btn-secondary  room-button bg-base-content" style = "" > -->
                        <button on:click={ () => state = 2} class=" font-semibold  btn-outline btn-info border border-primary room-button text-neutral" >
                        <div>{seat.state}   </div>
                        
                    </button>
                </div>
            {/each}
            </div>
    </div>
</div>

</div>

{/if}
<style>
    .room-button {
        width: 80px;
        height: 35px;
        /* display: flex; */
        /* flex-direction: column;
        justify-content: center;
        align-items: center;
        margin: 5px
        /* border: 1px solid #dbdee6; */
        /* background-color: #2d5653; */
        /* cursor: pointer; */
        font-family: Comic Sans MS;
        font-size: 15px;
        /* margin: 2px; */
         /* border: 1px solid #758bc6; */
        /* margin: 5px */
    }

    .top-left-button {
    width: 100px;
    position: absolute;
    top: 10px;
    left: 10px;
    padding: 10px;
    /* background-color: white;
    border: 1px solid #ccc; */
    cursor: pointer;
    background-color:rgb(46, 80, 81)
  }
</style>