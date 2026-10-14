import { defineConfig } from 'vite';

const base = process.env.BASE_PATH || '/';

export default defineConfig({
  root: '.',
  publicDir: 'public',
  base,
  build: {
    outDir: 'dist',
    target: 'esnext',
    rollupOptions: {
      output: {
        manualChunks: undefined
      }
    }
  },
  server: {
    headers: {
      'Cross-Origin-Opener-Policy': 'same-origin',
      'Cross-Origin-Embedder-Policy': 'require-corp'
    }
  },
  worker: { format: 'es' },
  optimizeDeps: { exclude: ['@webr/webassembly'] }
});
