#!/usr/local/bin/php
<?php

/*
 *    Copyright (C) 2015 Deciso B.V.
 *    Copyright (C) 2023 Cedrik Pischem
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
 */

require_once("config.inc");
require_once("certs.inc");
require_once("legacy_bindings.inc");

use OPNsense\Core\Config;

$configObj = Config::getInstance()->object();
$temp_dir = '/usr/local/etc/caddy/certificates/';

// Function to extract and save certificates
function extract_and_save_certificates($configObj, $temp_dir) {
    // Traverse through certificates
    foreach ($configObj->cert as $cert) {
        $cert_refid = (string)$cert->refid;
        $cert_content = base64_decode((string)$cert->crt);
        $key_content = base64_decode((string)$cert->prv);

        // Save the certificate
        file_put_contents($temp_dir . $cert_refid . '.pem', $cert_content);
        chmod($temp_dir . $cert_refid . '.pem', 0600);

        // Save the private key
        file_put_contents($temp_dir . $cert_refid . '.key', $key_content);
        chmod($temp_dir . $cert_refid . '.key', 0600);

        // Handle CA if exists to create a certificate bundle
        if (!empty($cert->caref)) {
            foreach ($configObj->ca as $ca) {
                if ((string)$cert->caref == (string)$ca->refid) {
                    $ca_content = base64_decode((string)$ca->crt);
                    file_put_contents($temp_dir . $cert_refid . '.pem', $cert_content . "\n" . $ca_content);
                    chmod($temp_dir . $cert_refid . '.pem', 0600);
                }
            }
        }
    }
}

extract_and_save_certificates($configObj, $temp_dir);
echo "Certificates, keys, and CA chains extracted to $temp_dir\n";
?>
