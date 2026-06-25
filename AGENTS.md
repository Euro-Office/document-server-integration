# document-server-integration — Euro-Office API Integration Reference

@../AGENTS.md

Guidance for Claude Code (and other AI agents) working in **document-server-integration** — reference implementations for host applications.

## What this repo is
A collection of insecure, didactic implementation examples across 11 programming languages/frameworks demonstrating how an external application communicates with the Euro-Office API.

## Licensing Guardrails & Core Architecture
- **THE LICENSING RULE:** Unlike the main repository submodules which are under the strict AGPL-3.0 license, this repository is explicitly licensed under **Apache-2.0**.
    - **CRITICAL:** Every new file contributed here MUST contain the Apache-2.0 copyright header block. Committing AGPL-3.0 headers here creates severe compliance violations.
- **The `/track` Saving Lifecycle:** The `/track` POST callback endpoint is the absolute core of the architecture. When the Document Server finishes an editing session, it fires data to this endpoint.
    - **CRITICAL FAIL MODE:** If the host application returns a slow response, handles the JWT incorrectly, or suffers a timeout, the user edits are silently lost. Study the Node.js `/track` handler in `web/documentserver-example/nodejs/app.js` and the `documentService` helper (`helpers/documentService.js`) as the standard model.
- **JWT Cryptographic Verification:** All communication between the host and Document Server must pass signed JWT tokens. Mismatched keys trigger silent HTTP 403 errors on the callback URL with zero debug logs.

## Rules
- **Never** introduce production hardening, standard login authentications, or complex access control logic to these files; doing so obscures the minimal integration patterns they exist to teach.
- **Never** introduce a new language example without implementing the absolute minimum baseline flow: Document Open, JWT Generation, and the `/track` Callback.
- **Never** commit code with AGPL-3.0 license headers.

## Findings & Long-tail
No centralized findings store exists in this repository yet. Document edge cases in code comments or GitHub issues until one is established.