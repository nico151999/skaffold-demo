import type { LayoutServerLoad } from './$types';

export const load = (() => {
    return {
        baseURL: (process.env.API_BASE_URL ?? (() => {throw new Error('base URL not defined')})()) as string,
        basePath: (process.env.BASE_PATH ?? (() => {throw new Error('base path not defined')})()) as string
    };
}) satisfies LayoutServerLoad;