import { writable } from 'svelte/store';

export const PlayerID = writable("");


export const UIstate = writable(0);
	// 0 is thong tin tau
	// 1 is mua ve
	// 2 is Sign In
	// 3 is Sign Up
	// 4 LeaderBoard
export const PlayerList = writable([]);

export const drawSettings = writable({ color: '#000000', size: 4 });