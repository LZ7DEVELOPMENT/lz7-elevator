const resourceName = typeof GetParentResourceName === 'function'
    ? GetParentResourceName()
    : 'lz7-elevator';

const elevator = document.getElementById('elevator');
const title = document.getElementById('title');
const display = document.getElementById('display');
const currentFloorText = document.getElementById('current-floor');
const closeButton = document.getElementById('close');
const keypad = document.querySelector('.keypad');
const elevatorSound = new Audio('elevator.ogg');
elevatorSound.volume = 0.55;

let selected = '';
let availableFloors = new Set();
let currentFloor = null;

function post(name, data = {}) {
    fetch(`https://${resourceName}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify(data)
    });
}

function setDisplay(value, isError = false) {
    display.textContent = value;
    display.classList.toggle('is-error', isError);
}

function resetSelection() {
    selected = '';
    setDisplay('SELECT');
}

function pressKey(value) {
    if (value === '10') {
        selected = '10';
    } else if (selected.length < 2) {
        selected += value;
    }

    setDisplay(selected || 'SELECT');
}

function enterSelection() {
    if (!selected) return;

    const floor = Number(selected);
    if (!availableFloors.has(floor)) {
        setDisplay('NO FLOOR', true);
        setTimeout(resetSelection, 750);
        return;
    }

    if (floor === currentFloor) {
        setDisplay('CURRENT', true);
        setTimeout(resetSelection, 900);
        return;
    }

    elevatorSound.currentTime = 0;
    elevatorSound.play().catch(() => {});
    post('selectFloor', { floor });
}

keypad.addEventListener('click', (event) => {
    const button = event.target.closest('button');
    if (!button) return;

    if (button.dataset.enter) {
        enterSelection();
        return;
    }

    pressKey(button.dataset.key);
});

closeButton.addEventListener('click', () => post('close'));

document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        post('close');
        return;
    }

    if (event.key === 'Enter') {
        enterSelection();
        return;
    }

    if (/^\d$/.test(event.key)) {
        pressKey(event.key);
    }
});

window.addEventListener('message', (event) => {
    const data = event.data || {};

    if (data.action === 'open') {
        availableFloors = new Set((data.floors || []).map((floor) => Number(floor.number)));
        currentFloor = Number(data.currentFloor);
        title.textContent = data.title || 'Elevator';
        currentFloorText.textContent = `CURRENT FLOOR: ${currentFloor}`;
        resetSelection();
        elevator.classList.add('is-open');
        elevator.setAttribute('aria-hidden', 'false');
        return;
    }

    if (data.action === 'close') {
        elevator.classList.remove('is-open');
        elevator.setAttribute('aria-hidden', 'true');
        currentFloor = null;
        resetSelection();
        return;
    }

    if (data.action === 'error') {
        setDisplay('NO FLOOR', true);
        setTimeout(resetSelection, 750);
    }

    if (data.action === 'sameFloor') {
        setDisplay('CURRENT', true);
        setTimeout(resetSelection, 900);
    }
});
