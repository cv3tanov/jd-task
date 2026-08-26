'use strict';

const body = document.body;
const title = document.getElementById('title');
const description = document.getElementById('description');
const closeKey = document.getElementById('close-key');

window.addEventListener('message', ({ data: message }) => {
    if (!message || typeof message.action !== 'string') return;
    if (message.action === 'hide') {
        body.classList.remove('visible');
        return;
    }
    if (message.action !== 'show' || !message.data) return;

    title.textContent = String(message.data.title ?? 'Текуща задача');
    description.textContent = String(message.data.description ?? '');
    closeKey.textContent = String(message.data.closeKey ?? 'G').toUpperCase();
    body.classList.remove('visible');
    requestAnimationFrame(() => body.classList.add('visible'));
});
