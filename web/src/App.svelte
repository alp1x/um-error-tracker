<script lang="ts">
    import { onMount } from 'svelte';
    import { ReceiveNUI } from "./utils/ReceiveNUI";
    import { SendNUI } from "./utils/SendNUI";
    import TrackerBoard from "./lib/TrackerBoard.svelte";

    let openTracker: boolean = false;

    ReceiveNUI("openTracker", async () => {
      openTracker = true;
    });

    function handleKeydown(event: KeyboardEvent) {
      if (event.key === "Escape") {
        openTracker = false;
        SendNUI("closeTracker", {});
      }
    }

    onMount(() => {
      window.addEventListener('keydown', handleKeydown);
      SendNUI("trackerNUIReady", {});
      return () => window.removeEventListener('keydown', handleKeydown)
    });


  interface CustomWindow extends Window {
    invokeNative: (action: string, url: string) => void;
  }

  declare let window: CustomWindow;

  function openGithubRepo() {
    window.invokeNative('openUrl', 'https://github.com/alp1x/um-error-tracker');
  }
</script>

{#if openTracker}
  <main>
    <div class="flex justify-center items-center h-screen">
      <div class="bg-color p-6 rounded-lg shadow-lg" style="width: 70rem">
        <div class="flex justify-between items-center">
          <h2 class="text-sm font-bold text-white font-bold mb-3">🚧 um-error-tracker <small>version?</small></h2>
          <button class="cursor-pointer text-xs font-bold" on:click={openGithubRepo}>⭐ github</button>
        </div>
        <div class="grid grid-cols-3 gap-5">
          <TrackerBoard />
        </div>
      </div>
    </div>
  </main>
{/if}
