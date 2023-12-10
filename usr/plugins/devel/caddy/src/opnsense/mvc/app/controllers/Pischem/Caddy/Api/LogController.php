<?php

/**
 *    Copyright (C) 2023 Cedrik Pischem
 *
 *    All rights reserved.
 *
 *    Redistribution and use in source and binary forms, with or without
 *    modification, are permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *    THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 *    AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 *    AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 *    OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 *    POSSIBILITY OF SUCH DAMAGE.
 *
 */


namespace Pischem\Caddy\Api;

use OPNsense\Base\ApiControllerBase;
use OPNsense\Core\Backend;

class LogController extends ApiControllerBase
{
    public function getAction()
    {
        // Fetch query parameters from the request
        $current = $this->request->get('current', 'int', 1); // Current page
        $rowCount = $this->request->get('rowCount', 'int', 50); // Number of log lines per page
        $searchPhrase = $this->request->get('searchPhrase', 'string', ''); // Search phrase
        $severity = $this->request->get('severity', 'string', ''); // Severity filter

        // Instantiate OPNsense backend service
        $backend = new Backend();

        // Prepare and sanitize the arguments for the script
        $current = escapeshellarg($current);
        $rowCount = escapeshellarg($rowCount);
        $searchPhrase = escapeshellarg($searchPhrase);
        $severity = escapeshellarg($severity);

        // Execute your caddy_log.py script with the parameters
        $response = $backend->configdRun("caddy showlog {$current} {$rowCount} {$searchPhrase} {$severity}");

        // Decode the JSON response and return it
        return json_decode($response, true);
    }
}
