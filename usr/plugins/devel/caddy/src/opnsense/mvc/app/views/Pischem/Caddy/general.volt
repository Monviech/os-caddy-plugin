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


<div style="background-color: white; padding: 10px; border: 1px solid #ddd;">
    <div class="content">
        <h1>Caddy General Settings</h1>
        {{ partial("layout_partials/base_form", ['fields': generalForm, 'action': '/ui/caddy/general', 'id': 'frm_GeneralSettings']) }}
    </div>
</div>

<div style="margin-top: 20px; width: 100%; background-color: white; padding: 5px; border: 1px solid #ddd;">
    <button id="applyGeneralAct" class="btn btn-primary" type="button" style="margin-left: 4px;"><b>Apply</b></button>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        var data_get_map = {'frm_GeneralSettings':"/api/caddy/General/get"};
        mapDataToFormUI(data_get_map).done(function(data){
            console.log("Fetched data:", data); // Log the fetched data
            var generalSettings = data.frm_GeneralSettings.caddy.general;

            // Populate TlsAutoHttps dropdown
            var tlsAutoHttpsSelect = $('#caddy\\.general\\.TlsAutoHttps');
            tlsAutoHttpsSelect.empty(); // Clear existing options
            $.each(generalSettings.TlsAutoHttps, function(key, option) {
                if (key !== "") {  // Filter out the unwanted "None" option
                    tlsAutoHttpsSelect.append(new Option(option.value, key, false, option.selected === 1));
                }
            });

            // Populate TlsDnsProvider dropdown
            var tlsDnsProviderSelect = $('#caddy\\.general\\.TlsDnsProvider');
            tlsDnsProviderSelect.empty(); // Clear existing options
            $.each(generalSettings.TlsDnsProvider, function(key, option) {
                if (key !== "") {  // Filter out the unwanted "None" option
                    tlsDnsProviderSelect.append(new Option(option.value, key, false, option.selected === 1));
                }
            });

            // Refresh selectpicker for these dropdowns
            $('.selectpicker').selectpicker('refresh');
        });

        // Link save button to API set action
        $("#applyGeneralAct").click(function(){
            saveFormToEndpoint(url="/api/caddy/general/set", formid='frm_GeneralSettings', callback_ok=function(){
                // Fetch the updated general settings
                fetch('/api/caddy/General/get')
                    .then(response => response.json())
                    .then(data => {
                        // Check the updated status of Caddy
                        if (data.caddy.general.enabled === "1") {
                            // Caddy enabled, start the service
                            $.ajax({
                                url: "/api/caddy/service/restart",
                                method: "POST",
                                success: function(data) {
                                    console.log("Caddy service started successfully:", data);
                                    // Reload the page after the operation completes
                                    location.reload();
                                },
                                error: function(xhr, status, error) {
                                    console.error("Failed to start Caddy service:", error);
                                }
                            });
                        } else {
                            // Caddy disabled, stop the service
                            $.ajax({
                                url: "/api/caddy/service/stop",
                                method: "POST",
                                success: function(data) {
                                    console.log("Caddy service stopped successfully:", data);
                                    // Reload the page after the operation completes
                                    location.reload();
                                },
                                error: function(xhr, status, error) {
                                    console.error("Failed to stop Caddy service:", error);
                                }
                            });
                        }
                    })
                    .catch(error => console.error('Error fetching updated Caddy general settings:', error));
            });
        });
    });
</script>
