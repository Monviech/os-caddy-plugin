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

    // 1. Check domain-port combinations
    // 2. Check subdomain-port combinations
    private function checkForUniquePortCombos($items, $messages, $type = 'domain')
    {
        $combos = [];
        foreach ($items as $item) {
            $fromDomainOrSubdomain = (string) $item->FromDomain;
            $fromPort = (string) $item->FromPort;

            // Default ports are treated as a special case
            if ($fromPort === '') {
                $defaultPorts = ['80', '443'];
            } else {
                $defaultPorts = [$fromPort];
            }

            foreach ($defaultPorts as $port) {
                // Create a unique key for domain/subdomain-port combination
                $comboKey = $fromDomainOrSubdomain . ':' . $port;

                // Check for duplicate combinations
                if (isset($combos[$comboKey])) {
                    $domainField = $type === 'domain' ? "reverse.FromDomain" : "subdomain.FromDomain";
                    $portField = $type === 'domain' ? "reverse.FromPort" : "subdomain.FromPort";

                    $messages->appendMessage(new Message(
                        gettext("Duplicate entry: The combination of $type '$fromDomainOrSubdomain' and port '$port' is already used. Each $type and port pairing must be unique."),
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
    }

    // 3. Check that subdomains are under a wildcard or exact domain
    private function endsWith($haystack, $needle)
    {
        $length = strlen($needle);
        if ($length == 0) {
            return true;
        }
        return (substr($haystack, -$length) === $needle);
    }

    private function checkSubdomainsAgainstDomains($subdomains, $domains, $messages)
    {
        $wildcardDomainList = [];
        foreach ($domains as $domain) {
            if ((string) $domain->enabled === '1') {
                $domainName = (string) $domain->FromDomain;
                if (str_starts_with($domainName, '*.')) {
                    // Map wildcard domain to its base (e.g., '*.example.com' -> 'example.com')
                    $wildcardBase = substr($domainName, 2);
                    $wildcardDomainList[$wildcardBase] = $domainName;
                }
            }
        }

        foreach ($subdomains as $subdomain) {
            if ((string) $subdomain->enabled === '1') {
                $subdomainName = (string) $subdomain->FromDomain;
                $subdomainBase = implode('.', array_slice(explode('.', $subdomainName), -2));

                // Check if subdomain's base domain has a corresponding wildcard domain
                $isValid = false;
                    foreach ($wildcardDomainList as $baseDomain => $wildcardDomain) {
                        if ($this->endsWith($subdomainName, $baseDomain)) {
                            $isValid = true;
                            break;
                        }
                    }

                if (!$isValid) {
                    $messages->appendMessage(new Message(
                        gettext("Invalid subdomain configuration: '$subdomainName' does not fall under any configured wildcard domain."),
                        "subdomain.FromDomain",
                        "InvalidSubdomain"
                    ));
                }
            }
        }
    }

    // 4. Check for conflicts between wildcard and base domains
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

    // Perform the actual validation
    public function performValidation($validateFullModel = false)
    {
        $messages = parent::performValidation($validateFullModel);

        // 1. Check domain-port combinations
        $this->checkForUniquePortCombos($this->reverseproxy->reverse->iterateItems(), $messages, 'domain');

        // 2. Check subdomain-port combinations
        $this->checkForUniquePortCombos($this->reverseproxy->subdomain->iterateItems(), $messages, 'subdomain');

        // 3. Check that subdomains are under a wildcard or exact domain
        $this->checkSubdomainsAgainstDomains($this->reverseproxy->subdomain->iterateItems(), $this->reverseproxy->reverse->iterateItems(), $messages);

        // 4. Check for conflicts between wildcard and base domains
        $this->checkForWildcardAndBaseDomainConflicts($this->reverseproxy->reverse->iterateItems(), $messages);

        return $messages;

    }
}
