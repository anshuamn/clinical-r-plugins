import { WebR } from '@webr/webassembly';
import { Shiny } from '@webr/shiny';

const loadingOverlay = document.getElementById('loading-overlay');
const loadingText = document.getElementById('loading-text');
const appContainer = document.getElementById('shiny-app');

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/webr-serviceworker.js', { scope: './' })
    .then(reg => { console.log('SW registered:', reg.scope); reg.update(); })
    .catch(err => console.warn('SW registration failed:', err));
}

function setLoading(text) { loadingText.textContent = text; }

async function init() {
  setLoading('Starting webR...');
  const webr = await WebR.create({
    channel: 'main',
    packages: ['rtables', 'tern', 'gtsummary', 'r2rtf', 'haven', 'dplyr', 'tidyr', 'stringr', 'jsonlite'],
    repo: 'https://cloud.r-project.org/'
  });

  setLoading('Loading Shiny...');
  const shiny = new Shiny(webr, { root: '/src/app.R', container: appContainer });
  await shiny.mount();

  loadingOverlay.style.display = 'none';
  appContainer.style.display = 'block';
  window.webr = webr; window.shiny = shiny;
}

init().catch(err => { console.error(err); setLoading(`Error: ${err.message}`); loadingText.style.color = '#dc2626'; });
