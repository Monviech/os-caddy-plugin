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

namespace Pischem\Caddy;

use OPNsense\Base\BaseModel;
use Phalcon\Messages\Message;

class Caddy extends BaseModel
{
    private function checkForUniquePortCombos($items, $messages, $type = 'domain')
    {
        $combos = [];
        foreach ($items as $item) {
            $fromDomainOrSubdomain = (string) $item->FromDomain;
            $fromPort = (string) $item->FromPort;

            // Treat ports 80 and 443 as default ports
            if ($fromPort === '' || $fromPort === '80' || $fromPort === '443') {
                $fromPort = 'default';
            }

            // Create a unique key for domain/subdomain-port combination
            $comboKey = $fromDomainOrSubdomain . ':' . $fromPort;

            // Check for duplicate combinations
            if (isset($combos[$comboKey])) {
                $domainField = $type === 'domain' ? "reverse.FromDomain" : "subdomain.FromDomain";
                $portField = $type === 'domain' ? "reverse.FromPort" : "subdomain.FromPort";

                $messages->appendMessage(new Message(
                    gettext("Duplicate entry: The combination of $type '$fromDomainOrSubdomain' and port '$fromPort' is already used. Each $type and port pairing must be unique."),
                    $domainField,
                    "Duplicate" . ucfirst($type) . "Port"
                ));
                $messages->appendMessage(new Message(
                    gettext("Duplicate entry: This port is already used for the $type '$fromDomainOrSubdomain'. Please choose a different port or $type."),
                    $portField,
                    "Duplicate" . ucfirst($type) . "Port"
                ));
            } else {
                $combos[$comboKey] = true;
            }
        }
    }
    
    private function checkSubdomainsAgainstDomains($subdomains, $domains, $messages)
    {
        $domainList = [];
        foreach ($domains as $domain) {
            if ((string) $domain->enabled === '1') {
                $domainName = (string) $domain->FromDomain;
                $domainList[$domainName] = $domainName;
            }
        }

        foreach ($subdomains as $subdomain) {
            if ((string) $subdomain->enabled === '1') {
                $subdomainName = (string) $subdomain->FromDomain;
                // Extract the second-level domain and higher (e.g., example.com from cat.example.com)
                $parentDomain = implode('.', array_slice(explode('.', $subdomainName), -2));

                // Check if the subdomain is under a wildcard domain or the exact domain
                if (!isset($domainList['*.' . $parentDomain]) && $subdomainName !== $parentDomain) {
                    $messages->appendMessage(new Message(
                        gettext("Invalid subdomain configuration: '$subdomainName' must be under a wildcard domain like '*.$parentDomain' or be an exact domain itself."),
                        "subdomain.FromDomain",
                        "InvalidSubdomain"
                    ));
                }
            }
        }
    }
    
    private function checkForWildcardAndBaseDomainConflicts($domains, $messages)
    {
        $domainList = [];
        foreach ($domains as $domain) {
            if ((string) $domain->enabled === '1') {
                $domainName = (string) $domain->FromDomain;
                $domainList[$domainName] = true;

                // Check for wildcard or base domain conflict
                if (str_starts_with($domainName, '*.')) {
                    $baseDomain = substr($domainName, 2);
                    if (isset($domainList[$baseDomain])) {
                        $messages->appendMessage(new Message(
                            gettext("Invalid domain configuration: Cannot create wildcard domain '$domainName' because base domain '$baseDomain' exists."),
                            "reverse.FromDomain",
                            "WildcardBaseConflict"
                        ));
                    }
                } else {
                    $wildcardDomain = '*.' . $domainName;
                    if (isset($domainList[$wildcardDomain])) {
                        $messages->appendMessage(new Message(
                            gettext("Invalid domain configuration: Cannot create base domain '$domainName' because wildcard domain '$wildcardDomain' exists."),
                            "reverse.FromDomain",
                            "BaseWildcardConflict"
                        ));
                    }
                }
            }
        }
    }
    
    private function checkForUniqueHandlePaths($handles, $domains, $subdomains, $messages)
    {
        $handlePathCombos = [];

        // Convert Generators to arrays
        $domainsArray = iterator_to_array($domains);
        $subdomainsArray = iterator_to_array($subdomains);

        // Create associative arrays for quick lookup by UUID
        $domainLookup = [];
        foreach ($domainsArray as $domain) {
            $domainUUID = (string) $domain->getAttribute('uuid');
            $domainLookup[$domainUUID] = (string) $domain->FromDomain;
        }

        $subdomainLookup = [];
        foreach ($subdomainsArray as $subdomain) {
            $subdomainUUID = (string) $subdomain->getAttribute('uuid');
            $subdomainLookup[$subdomainUUID] = (string) $subdomain->FromDomain;
        }

        foreach ($handles as $handle) {
            if ((string) $handle->enabled === '1') {
                $handlePath = (string) $handle->HandlePath;
                $domainUUID = (string) $handle->reverse;
                $subdomainUUID = (string) $handle->subdomain;

                $keyDomain = isset($domainLookup[$domainUUID]) ? $domainLookup[$domainUUID] : '';
                $keySubdomain = isset($subdomainLookup[$subdomainUUID]) ? $subdomainLookup[$subdomainUUID] : '';

                // Create a unique key for handle path within each domain and subdomain
                $pathKey = $keyDomain . ':' . $keySubdomain . ':' . $handlePath;

                if (isset($handlePathCombos[$pathKey])) {
                    $messages->appendMessage(new Message(
                        gettext("Duplicate entry: Handle path '$handlePath' is already used within the domain/subdomain combination '$keyDomain/$keySubdomain'. Each handle path must be unique per domain or domain/subdomain combination."),
                        "handle.HandlePath",
                        "DuplicateHandlePath"
                    ));
                } else {
                    $handlePathCombos[$pathKey] = true;
                }
            }
        }
    }

    public function performValidation($validateFullModel = false)
    {
        $messages = parent::performValidation($validateFullModel);

        // Check domain-port combinations
        $this->checkForUniquePortCombos($this->reverseproxy->reverse->iterateItems(), $messages, 'domain');

        // Check subdomain-port combinations
        $this->checkForUniquePortCombos($this->reverseproxy->subdomain->iterateItems(), $messages, 'subdomain');

        // Check that subdomains are under a wildcard or exact domain
        $this->checkSubdomainsAgainstDomains($this->reverseproxy->subdomain->iterateItems(), $this->reverseproxy->reverse->iterateItems(), $messages);
        
        // Check for conflicts between wildcard and base domains
        $this->checkForWildcardAndBaseDomainConflicts($this->reverseproxy->reverse->iterateItems(), $messages);
        
        // Check for unique handle paths among all domain and subdomain combinations
        $this->checkForUniqueHandlePaths(
            $this->reverseproxy->handle->iterateItems(),
            $this->reverseproxy->reverse->iterateItems(),
            $this->reverseproxy->subdomain->iterateItems(),
            $messages
        );

        return $messages;
    }
}
