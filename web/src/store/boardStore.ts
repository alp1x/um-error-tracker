import { writable } from 'svelte/store';

interface Item {
    id: number;
    name: string;
}

interface Column {
    id: number;
    name: string;
    description?: string;
    items: Item[];
}

type Board = Column[];

const initialBoard: Board = [
    {
        id: 1,
        name: "errors",
        items: []
    },
    {
        id: 2,
        name: "warnings",
        items: []
    },
    {
        id: 3,
        name: "updates",
        items: []
    },
    {
        id: 4,
        name: "fxmanifest",
        items: []
    },
    {
        id: 5,
        name: "inprogress",
        items: []
    },
    {
        id: 6,
        name: "fixed",
        items: []
    },
];

export const board = writable<Board>(initialBoard);
