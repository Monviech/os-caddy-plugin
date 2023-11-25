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

use OPNsense\Base\ApiMutableModelControllerBase;
use OPNsense\Core\Config;

class ReverseProxyController extends ApiMutableModelControllerBase
{
    protected static $internalModelName = 'caddy';
    protected static $internalModelClass = 'Pischem\Caddy\Caddy';

    // Since we're only dealing with the reverse proxy section, we don't need a filter or wrapDefaults.

    public function searchAction()
    {
        // Automatically return all reverse proxy entries without specifying fields
        return $this->searchBase('reverseproxy.reverse', array_keys(get_object_vars($this->getModel()->reverseproxy->reverse)));
    }

    public function getAction($uuid = null)
    {
        $mdlCaddy = new \Pischem\Caddy\Caddy();
        if ($uuid !== null) {
            // Fetch that specific reverse proxy setting
            $node = $mdlCaddy->getNodeByReference('reverseproxy.reverse.' . $uuid);
            if ($node != null) {
                return ['reverse' => [$uuid => $node->getNodes()]];
            }
            return []; // Return an empty array if the UUID is not found
        } else {
            // Fetch all reverse proxy settings indexed by UUID
            $result = [];
            foreach ($mdlCaddy->reverseproxy->reverse->iterateItems() as $node) {
                $uuid = $node->getAttributes()['uuid'];
                $result[$uuid] = $node->getNodes();
            }
            return ['reverse' => $result];
        }
    }
    
    
    public function setAction($uuid = null)
    {
        if ($this->request->isPut()) {
            $rawPutData = $this->request->getRawBody();
            $putData = json_decode($rawPutData, true);
            if ($putData === null || !isset($putData['reverse'])) {
                return ["result" => "failed", "validations" => ["Invalid input format"]];
            }
            
            // If the UUID is not provided in the URL, attempt to extract it from the data
            if ($uuid === null && isset($putData['reverse']['uuid'])) {
                $uuid = $putData['reverse']['uuid'];
            }
            
            if ($uuid === null) {
                return ["result" => "failed", "validations" => ["UUID not provided"]];
            }
            
            // Fetch the node reference to update
            $node = $this->getModel()->getNodeByReference('reverseproxy.reverse.' . $uuid);
            if ($node != null) {
                // Overwrite the node's data with the new data
                foreach ($putData['reverse'] as $key => $value) {
                    $node->$key = $value;
                }
                
                // Save the changes if the model is valid
                $validationMessages = $this->getModel()->performValidation();
                $errors = [];
                if ($validationMessages->count() > 0) {
                    // Collect validation errors
                    foreach ($validationMessages as $message) {
                        // Extract the last part of the field name
                        $fieldParts = explode('.', $message->getField());
                        $fieldName = end($fieldParts);
                        $errors["reverse.$fieldName"] = $message->getMessage();
                    }
                    return ["result" => "failed", "validations" => $errors];
                } else {
                    // No validation errors, save model
                    $this->getModel()->serializeToConfig();
                    Config::getInstance()->save();
                    return ["result" => "saved", "message" => "Reverse proxy entry updated"];
                }
            } else {
                return ["result" => "failed", "validations" => ["Reverse proxy entry with the specified UUID not found"]];
            }
        } else {
            return ["result" => "failed", "validations" => ["Only PUT method is allowed for this endpoint"]];
        }
    }


    public function addAction()
    {
        // This function will add a new reverse proxy entry and automatically generate a UUID
        $result = $this->addBase('reverse', 'reverseproxy.reverse');
        Config::getInstance()->save(); // Save the configuration to make sure the UUID is persisted
        return $result;
    }

    public function toggleAction($uuid, $enabled = null)
    {
        // This function will enable or disable a specific reverse proxy entry
        return $this->toggleBase('reverseproxy.reverse', $uuid, $enabled);
    }

    public function delAction($uuid)
    {
    if ($this->request->isPost()) {
        if ($uuid == null) {
            $uuid = $this->request->getPost("uuid");
        }

        // Check if UUID is provided
        if ($uuid != null) {
            // Fetch node reference
            $node = $this->getModel()->getNodeByReference('reverseproxy.reverse.' . $uuid);

            if ($node != null) {
                // Use the internal delete method
                $this->getModel()->reverseproxy->reverse->del($uuid);
                if ($this->getModel()->performValidation()->count() == 0) {
                    // Save changes if validation passed
                    $this->getModel()->serializeToConfig();
                    Config::getInstance()->save();

                    // Respond with success
                    return ["status" => "ok"];
                } else {
                    // Respond with validation errors
                    $validationMessages = $this->getModel()->performValidation();
                    foreach ($validationMessages as $message) {
                        return ["status" => "failed", "message" => $message];
                    }
                }
            } else {
                // Respond with error if node doesn't exist
                return ["status" => "failed", "message" => "Reverse proxy entry not found."];
            }
        } else {
            // Respond with error if UUID isn't provided
            return ["status" => "failed", "message" => "No UUID provided for deletion."];
        }
    } else {
        // Respond with error if not a POST request
        return ["status" => "failed", "message" => "Invalid request method."];
        }
    }
}

