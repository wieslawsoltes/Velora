/** Runtime paths are derived from the module URL, so repository subpaths work. */
export const STUDIO_ROOT=new URL('./',import.meta.url).href;
export const APP_ROOT=new URL('../',import.meta.url).href;
export const LOCAL_MODE=globalThis.VELORA_CONFIG?.storage==='indexeddb';
export const HOSTED_APP='https://velora-design-studio.wisodev.chatgpt.site';
export function assetURL(src){return src?.startsWith('/studio/')?new URL(src.slice(8),STUDIO_ROOT).href:src}
let resolver=null;
export function setMediaResolver(fn){resolver=fn}
export async function mediaURL(src){if(resolver&&src.startsWith('/api/assets/'))return resolver(src);return assetURL(src)}
