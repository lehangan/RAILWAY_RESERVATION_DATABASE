<script>
// @ts-nocheck

   
    import {UIstate } from "../store.ts";
    let username = '';
    let password = '';
    let error = 0;
     /**
       * @param {string} username
       * @param {string} password
       */
     function checkSignIn(username, password) {
        if (username == '1' && password == '1') {
          $UIstate = 1;
         // console.log(windowState)
          //$usernameCheck = username;
        } else {
          error = 1;
        }
      }
  </script>
  
  <slot />
  <div class = " myDiv">
    <div class="grid items-center h-200 " >
      <!-- <h class = "font-bold pb-10 " style = "font-size: px; color:darkcyan "> Welcome to Gartic Game</h> -->
      <h1 class = "font-sans font-bold pb-10 text-primary-content Topic"> Sign in</h1>
      
      <h3 class="font-sans font-semibold text-secondary-content" style="font-size: 22px; text-align: center; "> Email or Phone </h3>
      <div class = "font-sans centered-input font-semibold "><input bind:value={username} class = "myInput border-4 border-neutral  text-primary-content"/></div>
  
      <h3 class="font-sans font-semibold text-secondary"style="font-size: 22px; text-align: center; "> Password </h3>
      <div class = "font-sans centered-input font-semibold"> <input bind:value={password} class = "myInput border-4 border-neutral  text-primary-content"  /></div>
    </div>
    <div >
      <button class = "myButton btn btn-outline bg-accent text-secondary-content "  on:click={() => checkSignIn(username, password)}>
        Play
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" /></svg>
      </button>
  
      <button class = "myButton btn btn-outline bg-secondary text-secondary-content"  on:click={()=> $UIstate = 4}>
        Sign Up
        <!-- <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" /></svg> -->
      </button>
      <!-- <button class = "myButton btn btn-outline btn-accent" style="background-color:chocolate;color:white" on:click={() => windowState = 5}>
        Chat
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z" /></svg>
      </button> -->
    </div> 
  </div>
  
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