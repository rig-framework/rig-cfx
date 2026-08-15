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
    position: "top-center",
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