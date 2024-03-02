<?php

/**
 *    Copyright (C) 2023-2024 Cedrik Pischem
 *    Copyright (C) 2015 Deciso B.V.
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

use OPNsense\Base\IndexController;

class GeneralController extends IndexController
{
    public function indexAction()
    {
        // Assign the general settings form to the view
        $this->view->pick('Pischem/Caddy/general');
        $this->view->generalForm = $this->getForm("general");
        $this->view->dnsproviderForm = $this->getForm("dnsprovider");
        $this->view->dynamicdnsForm = $this->getForm("dynamicdns");
        $this->view->logsettingsForm = $this->getForm("logsettings");
        
        // Assign additional Forms for each supported DNS Provider 
        // in the order of the DNS Provider select picker for maintainability
        $this->view->dnsprovidercloudflareForm = $this->getForm("dnsprovidercloudflare");
        $this->view->dnsproviderduckdnsForm = $this->getForm("dnsproviderduckdns");
        $this->view->dnsproviderdigitaloceanForm = $this->getForm("dnsproviderdigitalocean");
        $this->view->dnsproviderdnspodForm = $this->getForm("dnsproviderdnspod");
        $this->view->dnsproviderhetznerForm = $this->getForm("dnsproviderhetzner");
        $this->view->dnsprovidergodaddyForm = $this->getForm("dnsprovidergodaddy");
        $this->view->dnsprovidergandiForm = $this->getForm("dnsprovidergandi");
        $this->view->dnsproviderionosForm = $this->getForm("dnsproviderionos");
        $this->view->dnsproviderdesecForm = $this->getForm("dnsproviderdesec");
        $this->view->dnsproviderporkbunForm = $this->getForm("dnsproviderporkbun");
        $this->view->dnsproviderroute53Form = $this->getForm("dnsproviderroute53");
        $this->view->dnsprovideracmednsForm = $this->getForm("dnsprovideracmedns");
        $this->view->dnsprovidernetlifyForm = $this->getForm("dnsprovidernetlify");
        $this->view->dnsprovidernamesiloForm = $this->getForm("dnsprovidernamesilo");
        $this->view->dnsprovidernjallaForm = $this->getForm("dnsprovidernjalla");
        $this->view->dnsprovidervercelForm = $this->getForm("dnsprovidervercel");
        $this->view->dnsprovidergoogleclouddnsForm = $this->getForm("dnsprovidergoogleclouddns");
        $this->view->dnsprovideralidnsForm = $this->getForm("dnsprovideralidns");
        $this->view->dnsproviderpowerdnsForm = $this->getForm("dnsproviderpowerdns");
        $this->view->dnsprovidertencentcloudForm = $this->getForm("dnsprovidertencentcloud");
        $this->view->dnsproviderdinahostingForm = $this->getForm("dnsproviderdinahosting");
        $this->view->dnsprovidermetanameForm = $this->getForm("dnsprovidermetaname");
        $this->view->dnsproviderhexonetForm = $this->getForm("dnsproviderhexonet");
        $this->view->dnsproviderddnssForm = $this->getForm("dnsproviderddnss");
        $this->view->dnsproviderlinodeForm = $this->getForm("dnsproviderlinode");
        $this->view->dnsprovidermailinaboxForm = $this->getForm("dnsprovidermailinabox");
        $this->view->dnsproviderovhForm = $this->getForm("dnsproviderovh");
        $this->view->dnsprovidernamecheapForm = $this->getForm("dnsprovidernamecheap");
        $this->view->dnsproviderazureForm = $this->getForm("dnsproviderazure");
        $this->view->dnsprovideropenstackdesignateForm = $this->getForm("dnsprovideropenstackdesignate");
    }
}
