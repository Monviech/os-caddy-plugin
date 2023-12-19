{#
 # Copyright (c) 2023 Cedrik Pischem
 # All rights reserved.
 #
 # Redistribution and use in source and binary forms, with or without modification,
 # are permitted provided that the following conditions are met:
 #
 # 1. Redistributions of source code must retain the above copyright notice,
 #    this list of conditions and the following disclaimer.
 #
 # 2. Redistributions in binary form must reproduce the above copyright notice,
 #    this list of conditions and the following disclaimer in the documentation
 #    and/or other materials provided with the distribution.
 #
 # THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 # AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 # AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 # OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 # SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 # INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 # CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 # ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 # POSSIBILITY OF SUCH DAMAGE.
 #}

<script>
    $(document).ready(function() {
        $("#reverseProxyGrid").UIBootgrid({
            search:'/api/caddy/ReverseProxy/searchReverseProxy/',
            get:'/api/caddy/ReverseProxy/getReverseProxy/',
            set:'/api/caddy/ReverseProxy/setReverseProxy/',
            add:'/api/caddy/ReverseProxy/addReverseProxy/',
            del:'/api/caddy/ReverseProxy/delReverseProxy/',
            toggle:'/api/caddy/ReverseProxy/toggleReverseProxy/',
        });

        $("#reverseSubdomainGrid").UIBootgrid({
            search:'/api/caddy/ReverseProxy/searchSubdomain/',
            get:'/api/caddy/ReverseProxy/getSubdomain/',
            set:'/api/caddy/ReverseProxy/setSubdomain/',
            add:'/api/caddy/ReverseProxy/addSubdomain/',
            del:'/api/caddy/ReverseProxy/delSubdomain/',
            toggle:'/api/caddy/ReverseProxy/toggleSubdomain/',
        });

        $("#reverseHandleGrid").UIBootgrid({
            search:'/api/caddy/ReverseProxy/searchHandle/',
            get:'/api/caddy/ReverseProxy/getHandle/',
            set:'/api/caddy/ReverseProxy/setHandle/',
            add:'/api/caddy/ReverseProxy/addHandle/',
            del:'/api/caddy/ReverseProxy/delHandle/',
            toggle:'/api/caddy/ReverseProxy/toggleHandle/',
        });

        // Initialize the Apply button using SimpleActionButton
        $("#reconfigureAct").SimpleActionButton();

        // Initialize the service control UI for 'caddy'
        updateServiceControlUI('caddy');
    });
</script>

<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#reverseProxyTab">Reverse Proxy</a></li>
    <li><a data-toggle="tab" href="#handleTab">Handle</a></li>
</ul>

<div class="tab-content content-box">

    <!-- Reverse Proxy Tab -->
    <div id="reverseProxyTab" class="tab-pane fade in active">
        <div style="background-color: white; padding: 10px; border: 1px solid #ddd;">
            <!-- Reverse Proxy -->
            <h1>Reverse Proxy Domains</h1>
            <div style="display: block;"> <!-- Common container -->
                <table id="reverseProxyGrid" class="table table-condensed table-hover table-striped" data-editDialog="DialogReverseProxy">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">ID</th>
                            <th data-column-id="enabled" data-width="6em" data-type="boolean" data-formatter="rowtoggle">Enabled</th>
                            <th data-column-id="FromDomain" data-type="string">Domain</th>
                            <th data-column-id="FromPort" data-type="string">Port</th>
                            <th data-column-id="DnsChallenge" data-type="boolean" data-formatter="boolean" data-visible="false">DNS-01</th>
                            <th data-column-id="CustomCertificate" data-type="string" data-visible="false">Custom Certificate</th>
                            <th data-column-id="Description" data-type="string">Description</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">Commands</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td>
                                <button id="addReverseProxyBtn" data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
        <div style="background-color: white; padding: 10px; margin-top: 20px; border: 1px solid #ddd;">
            <!-- Subdomains -->
            <h1>Reverse Proxy Subdomains</h1>
            <div style="display: block;"> <!-- Common container -->
                <table id="reverseSubdomainGrid" class="table table-condensed table-hover table-striped" data-editDialog="DialogSubdomain">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">ID</th>
                            <th data-column-id="enabled" data-width="6em" data-type="boolean" data-formatter="rowtoggle">Enabled</th>
                            <th data-column-id="reverse" data-type="string">Domain</th>
                            <th data-column-id="FromDomain" data-type="string">Subdomain</th>
                            <th data-column-id="FromPort" data-type="string">Port</th>
                            <th data-column-id="Description" data-type="string">Description</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">Commands</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td>
                                <button id="addSubdomainBtn" data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>

    <!-- Handle Tab -->
    <div id="handleTab" class="tab-pane fade">
        <div style="background-color: white; padding: 10px; border: 1px solid #ddd;">
            <h1>Handle</h1>
            <div style="display: block;"> <!-- Common container -->
                <table id="reverseHandleGrid" class="table table-condensed table-hover table-striped" data-editDialog="DialogHandle">
                    <thead>
                        <tr>
                            <th data-column-id="uuid" data-type="string" data-identifier="true" data-visible="false">ID</th>
                            <th data-column-id="enabled" data-width="6em" data-type="boolean" data-formatter="rowtoggle">Enabled</th>
                            <th data-column-id="reverse" data-type="string">Domain</th>
                            <th data-column-id="subdomain" data-type="string">Subomain</th>
                            <th data-column-id="HandleType" data-type="string" data-visible="false">Handle Type</th>
                            <th data-column-id="HandlePath" data-type="string">Handle Path</th>
                            <th data-column-id="ToDomain" data-type="string">Backend Domain</th>
                            <th data-column-id="ToPort" data-type="string">Backend Port</th>
                            <th data-column-id="HttpTls" data-type="boolean" data-formatter="boolean" data-visible="false">TLS</th>
                            <th data-column-id="HttpTlsTrustedCaCerts" data-type="string" data-visible="false">TLS CA</th>
                            <th data-column-id="HttpNtlm" data-type="boolean" data-formatter="boolean" data-visible="false">NTLM</th>
                            <th data-column-id="Description" data-type="string">Description</th>
                            <th data-column-id="commands" data-width="7em" data-formatter="commands" data-sortable="false">Commands</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td></td>
                            <td>
                                <button id="addReverseHandleBtn" data-action="add" type="button" class="btn btn-xs btn-default"><span class="fa fa-plus"></span></button>
                                <button data-action="deleteSelected" type="button" class="btn btn-xs btn-default"><span class="fa fa-trash-o"></span></button>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Reconfigure Button -->
<div style="margin-top: 20px; width: 100%; background-color: white; padding: 5px; border: 1px solid #ddd;">
    <button class="btn btn-primary" id="reconfigureAct"
        data-endpoint="/api/caddy/service/reconfigure"
        data-label="{{ lang._('Apply') }}"
        data-error-title="{{ lang._('Error reconfiguring Caddy') }}"
        type="button"
    ><b>Apply</b></button>
</div>

{{ partial("layout_partials/base_dialog",['fields':formDialogReverseProxy,'id':'DialogReverseProxy','label':lang._('Edit Reverse Proxy Domain')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogSubdomain,'id':'DialogSubdomain','label':lang._('Edit Reverse Proxy Subdomain')])}}
{{ partial("layout_partials/base_dialog",['fields':formDialogHandle,'id':'DialogHandle','label':lang._('Edit Handle')])}}
