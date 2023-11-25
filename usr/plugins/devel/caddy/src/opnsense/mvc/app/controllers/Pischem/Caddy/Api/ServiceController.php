<?php

/**
 *    Copyright (C) 2015 Deciso B.V.
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

class ServiceController extends ApiControllerBase
{
    /**
     * Reload Caddy configuration
     */
    public function restartAction()
    {
        $status = "failed";
        if ($this->request->isPost()) {
            $backend = new Backend();
            $bckresult = trim($backend->configdRun('caddy restart'));
            error_log("Backend response: " . $bckresult); // Log for debugging
            if ($bckresult == "OK") {
                $status = "ok";
            }
        }
        return array("status" => $status, "message" => "Reloading Caddy configuration");
    }

    /**
     * Stop Caddy service
     */
    public function stopAction()
    {
        $status = "failed";
        if ($this->request->isPost()) {
            $backend = new Backend();
            $bckresult = trim($backend->configdRun('caddy stop'));
            if ($bckresult == "OK") {
                $status = "ok";
            }
        }
        return array("status" => $status, "message" => "Stopping Caddy service");
    }

    /**
     * Start Caddy service
     */
    public function startAction()
    {
        $status = "failed";
        if ($this->request->isPost()) {
            $backend = new Backend();
            $bckresult = trim($backend->configdRun('caddy start'));
            if ($bckresult == "OK") {
                $status = "ok";
            }
        }
        return array("status" => $status, "message" => "Starting Caddy service");
    }
    
    /**
    * Test Action for Caddy service
    */
        public function testAction()
    {
        if ($this->request->isPost()) {
            $backend = new Backend();
            $response = json_decode(trim($backend->configdRun("caddy test")), true);
            return $response;
        } else {
            return array("status" => "failed");
        }
    }
}

