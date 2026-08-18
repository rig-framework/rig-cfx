/*
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
*/

// Components

import { Modal } from "./modal/js/modal.js";

// Core

import { Notify } from "./notify/js/notify.js";
import { UIBuilder } from "./framework/js/main.js";

// Initialisation

const NOTIFY = new Notify({
    position: "right-center",
    fill_direction: "up"
});

const HANDLERS = {}

// Handler Functions

HANDLERS.notify = (data) => {
    if (!data || !data.payload) {
        console.warn("[Notify] Missing payload.");
        return;
    }

    NOTIFY.show(data.payload);
};

HANDLERS.build_modal = (data) => {
    if (!data || !data.payload) {
        console.warn("[Modal] Missing payload.");
        return;
    }

    Modal.show({
        title: data.payload.title,
        options: data.payload.options || [],
        buttons: data.payload.buttons || []
    });
};

HANDLERS.remove_modal = (data) => {
    const container = data && data.payload && data.payload.container ? data.payload.container : "#ui_focus";
    Modal.remove(container);
};

HANDLERS.build_ui = (data) => {
    if (!data.payload) {
        console.warn("[UI Builder] No UI data provided");
        return;
    }

    if (window.ui_instance && typeof window.ui_instance.destroy === "function") {
        window.ui_instance.destroy();
        window.ui_instance = null;
    }

    const builder = new UIBuilder(data.payload);
    window.ui_instance = builder;
};

/**
 * Global message listener for all NUI messages.
 * Routes each message to its corresponding handler.
 */
window.addEventListener("message", (event) => {
    const { func } = event.data;
    const handler = HANDLERS[func];

    if (typeof handler !== "function") {
        console.warn(`Handler missing: ${func}`);
        return;
    }

    handler(event.data);
});