<script lang="ts">
	import { onDestroy } from 'svelte';
	import { flip } from 'svelte/animate';
	import { dndzone } from 'svelte-dnd-action';
	import { board } from '../store/boardStore';
	import { ReceiveNUI } from "../utils/ReceiveNUI";
	import { SendNUI } from "../utils/SendNUI";

	let updateTrackerTable: boolean = false;
	let intervalId: number | null | undefined;
	const flipDurationMs: number = 100;

	function handleDndConsiderCards(cid, e) {
		board.update(currentBoard => {
			const colIdx = currentBoard.findIndex(c => c.id === cid);
			currentBoard[colIdx].items = e.detail.items;
			return [...currentBoard];
		});
	}

	function handleDndFinalizeCards(cid, e) {
		board.update(currentBoard => {
			const colIdx = currentBoard.findIndex(c => c.id === cid);
			currentBoard[colIdx].items = e.detail.items;
			return [...currentBoard];
		});
	}

	ReceiveNUI("updateTrackerTable", async (data: Object) => {
		board.update(currentBoard => {
			Object.entries(data).forEach(([category, messageList]) => {
				const columnIndex = currentBoard.findIndex(c => c.name === category);
				if (columnIndex !== -1) {
					messageList.forEach((message: { id: any; line: any; }) => {
						currentBoard[columnIndex].items.push({ id: message.id, name: message.line });
					});
				}
			});
			return [...currentBoard];
		});
		updateTrackerTable = true;
	});

	$: if (updateTrackerTable) {
			intervalId = setInterval(() => {
			SendNUI("updateTrackerTable", {})
			}, 5000);
		} else if (intervalId) {
			clearInterval(intervalId);
			intervalId = null;
	}

	onDestroy(() => {
		if (intervalId) {
			clearInterval(intervalId);
		}
	});

	function regExpEscape(s: string) {
		return s.replace(/\^\d+/g, '');
	}
</script>

{#if updateTrackerTable}
		{#each $board as column (column.id)}
			<div class="box p-4 rounded" animate:flip="{{duration: flipDurationMs}}">
				<h3 class="font-bold text-sm p-3 rounded text-white">{column.name} <span class="{column.name + '-bg'} text-xs p-1 rounded">{column.items.length}</span></h3>

				<div class="column-content"
					use:dndzone={{items:column.items, flipDurationMs}}
					on:consider={(e) => handleDndConsiderCards(column.id, e)}
					on:finalize={(e) => handleDndFinalizeCards(column.id, e)}
					>
					{#if column.items.length !== 0}
						{#each column.items as item (item.id)}
							<div class="mt-2 text-xs rounded p-3 card-color text-gray-300 font-bold" animate:flip="{{duration: flipDurationMs}}">
								<span class="inline-block h-2 w-2 {column.name + '-bg'} rounded-full"></span>
								{regExpEscape(item.name)}
							</div>
						{/each}
					{:else}
						<div class="mt-2 text-xs text-white op-80 ">no data</div>
					{/if}
				</div>

			</div>
		{/each}
	{:else}
	<div class="flex justify-center items-center align-center">
		<h3>loading..</h3>
	</div>
{/if}