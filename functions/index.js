/**
 * Firebase Cloud Function to Proxy requests to ACE-Step VM
 * 
 * Why: Your Firebase app is HTTPS, but the VM API is HTTP. 
 * Browsers block "Mixed Content" (HTTPS calling HTTP).
 * This proxy runs on the server (Cloud Functions) to bridge the gap.
 */

const { onRequest } = require("firebase-functions/v2/https");
const axios = require("axios");

// VM IP from 'acestep-t4' creation
const VM_API_URL = "http://34.93.141.148:8001";

exports.aceStepProxy = onRequest({ cors: true }, async (req, res) => {
    try {
        // 1. Determine the target endpoint (e.g., /release_task or /query_result)
        // The client should pass the path in the query or body, or use a wildcard path
        // Simple approach: Map /aceStepProxy/release_task -> VM/release_task
        const path = req.path; // e.g. "/release_task"

        // 2. Forward the request to the VM
        const response = await axios({
            method: req.method,
            url: `${VM_API_URL}${path}`,
            data: req.body,
            params: req.query,
            headers: {
                // Forward content-type, but carefully
                "Content-Type": req.get("Content-Type") || "application/json"
            }
        });

        // 3. Return the VM's response to the client
        res.status(response.status).send(response.data);

    } catch (error) {
        console.error("Proxy Error:", error.message);
        if (error.response) {
            // The VM returned an error
            res.status(error.response.status).send(error.response.data);
        } else {
            // Network or other error
            res.status(500).send({ error: "Failed to connect to Music Generation VM" });
        }
    }
});
