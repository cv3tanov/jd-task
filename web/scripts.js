'use strict';

const body = document.body;
const title = document.getElementById('title');
const description = document.getElementById('description');
const closeKey = document.getElementById('close-key');
const timer = document.getElementById('timer');
const timerLabel = document.getElementById('timer-label');
const timerValue = document.getElementById('timer-value');

let deadline = null;
let lastSecond = null;

function updateTimer() {
    if (deadline === null) {
        timer.hidden = true;
        lastSecond = null;
        return;
    }

    const seconds = Math.max(0, Math.ceil((deadline - Date.now()) / 1000));
    if (seconds === lastSecond) return;

    lastSecond = seconds;
    const minutes = Math.floor(seconds / 60);
    timerValue.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds % 60).padStart(2, '0')}`;
    timer.hidden = false;
}

function applyData(data) {
    if (!data || typeof data !== 'object') return;
    title.textContent = String(data.title ?? 'Текуща задача');
    description.textContent = String(data.description ?? '');
    closeKey.textContent = String(data.closeKey ?? 'G').toUpperCase();
    timerLabel.textContent = String(data.timerLabel ?? 'Оставащо време');
    deadline = Number.isFinite(Number(data.duration)) ? Date.now() + Math.max(0, Number(data.duration)) : null;
    lastSecond = null;
    updateTimer();
}

window.addEventListener('message', ({ data: message }) => {
    if (!message || typeof message.action !== 'string') return;
    if (message.action === 'hide') {
        body.classList.remove('visible');
        return;
    }
    if (message.action === 'update') {
        applyData(message.data);
        return;
    }
    if (message.action !== 'show') return;
    applyData(message.data);
    body.classList.add('visible');
});

setInterval(updateTimer, 250);
