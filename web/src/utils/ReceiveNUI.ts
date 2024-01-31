import { onMount, onDestroy } from "svelte";

interface NuiMessage<T = unknown> {
  type: string;
  data: T;
}

/**
 * A function that manage events listeners for receiving data from the client scripts
 * @param type The specific `type` that should be listened for.
 * @param handler The callback function that will handle data relayed by this function
 *
 * @example
 * useNuiEvent<{VISIBILITY: true, wasVisible: 'something'}>('setVisible', (data) => {
 *   // whatever logic you want
 * })
 *
 **/

export function ReceiveNUI<T = unknown>(
  type: string,
  handler: (data: T) => void
) {
  const eventListener = (event: MessageEvent<NuiMessage<T>>) => {
    const { type: eventAction, data } = event.data;

    eventAction === type && handler(data);
  };
  onMount(() => window.addEventListener("message", eventListener));
  onDestroy(() => window.removeEventListener("message", eventListener));
}