<script>
// @ts-nocheck

  import "../app.css";
  import {UIstate } from "../store";
  import SignIn from "./SignIn.svelte";
  import Seat from "./Seat.svelte";
  let ga_di = "";
  let ga_den = "";
  let ngay_di = "";
 
</script>
{#if $UIstate == 2}
<SignIn/>
{:else if $UIstate == 1}
<Seat/>
{:else}
<slot />
<div class = " myDiv">
  <h3> Departure Station</h3>
  <input bind:value = {ga_di} />
  <h3> Arrival Station</h3>
  <input bind:value = {ga_den} />
  <h3> Departure Time</h3>
  <input bind:value = {ngay_di} />
  <button on:click={ () => $UIstate = 1}> Search </button>
</div>
{/if};

<style>
  :global(body) {
      margin: 0;

      /* background-image: url('./backgr3.png');  */
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
    
    }

  .myDiv {
    width: 1500px;
    height:850px;
    background-color: rgb(242, 246, 247);
    border: 1px solid #ccc;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  .Topic{
      text-align: center;
      padding: 50px; /* Adjust padding as needed */
      font-size: 50px; /* Adjust font size as needed */
      align-items: center;  
    }
   
      .myInput {
        /* background-color: rgb(102, 88, 105); */
        /* padding: 7px; */
        width: 300px; /* Set the width of the input */
        height: 35px; /* Set the height of the input */
        display: flex;
        justify-content: center;
        /* align-items: center; */
        margin-top: 10px; /* Adjust margin as needed */
        margin: 10px;
        align-items: center;
      }
      .myButton {
      /* position: absolute;
      top: 10px;
      left: 10px;
      padding: 10px; */
      width: 100px;
      height: 50px;
      /* background-color: white; */
      border: 1px solid #ccc;
      cursor: pointer;
    }
    .centered-input {
          display: flex;
          justify-content: center;
          align-items: center;
          /* margin-top: 10px; Adjust margin as needed */
      }
</style>