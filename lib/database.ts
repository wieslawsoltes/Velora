import {env} from 'cloudflare:workers';
export function database():D1Database{const db=(env as unknown as {DB?:D1Database}).DB;if(!db)throw Object.assign(new Error('Project storage is unavailable. Please try again.'),{status:503});return db}
export function bucket():R2Bucket{const b=(env as unknown as {BUCKET?:R2Bucket}).BUCKET;if(!b)throw Object.assign(new Error('Media storage is unavailable.'),{status:503});return b}
