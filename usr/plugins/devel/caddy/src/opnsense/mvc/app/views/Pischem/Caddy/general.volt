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
    <!-- Reconfigure Button with Pre-Action -->
    <button class="btn btn-primary" id="reconfigureAct"
            data-endpoint="/api/caddy/service/reconfigure"
            data-label="{{ lang._('Apply') }}"
            data-error-title="{{ lang._('Error reconfiguring Caddy') }}"
            type="button"
    ><b>Apply</b></button>
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

            // Initialize the Reconfigure button with a pre-action
            $("#reconfigureAct").SimpleActionButton({
                onPreAction: function() {
                    const dfd = $.Deferred();

                    // Save the form data
                    saveFormToEndpoint("/api/caddy/general/set", 'frm_GeneralSettings', function(){
                        dfd.resolve();  // Resolve the Deferred object after successful save
                    }, function() {
                        dfd.reject();   // Reject the Deferred object on failure
                    });

                    return dfd.promise();  // Return the promise
                },
                onAction: function(data, status) {
                    if (status === "success" && data && data['status'].toLowerCase() === 'ok') {
                    // Reload the page if the action was successful
                        location.reload();
                    } else {
                    // Handle any errors or unsuccessful actions
                        console.error("Action was not successful or an error occurred:", data);
                    }
                }
            });

            // Initialize the service control UI for 'caddy'
            updateServiceControlUI('caddy');

        });
    });
</script>
