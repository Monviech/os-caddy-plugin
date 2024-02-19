{#
 # Copyright (c) 2023-2024 Cedrik Pischem
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
<!-- Tab Navigation -->
<ul class="nav nav-tabs" data-tabs="tabs" id="maintabs">
    <li class="active"><a data-toggle="tab" href="#generalTab">General</a></li>
    <li><a data-toggle="tab" href="#dnsProviderTab">DNS Provider</a></li>
</ul>

<!-- Tab Content -->
<div class="tab-content content-box">
    <!-- General Tab -->
    <div id="generalTab" class="tab-pane fade in active">
        {{ partial("layout_partials/base_form", ['fields': generalForm, 'action': '/ui/caddy/general', 'id': 'frm_GeneralSettings']) }}
    </div>
    <!-- DNS Provider Tab -->
    <div id="dnsProviderTab" class="tab-pane fade">
        {{ partial("layout_partials/base_form", ['fields': dnsproviderForm, 'action': '/ui/caddy/general', 'id': 'frm_GeneralSettings']) }}
    </div>
</div>

<section class="page-content-main">
    <div class="content-box">
        <div class="col-md-12">
            <br/>
            <!-- Reconfigure Button with Pre-Action -->
            <button class="btn btn-primary" id="reconfigureAct"
                    data-endpoint="/api/caddy/service/reconfigure"
                    data-label="{{ lang._('Apply') }}"
                    data-error-title="{{ lang._('Error reconfiguring Caddy') }}"
                    type="button"
            ></button>
            <br/><br/>
        </div>
    </div>
</section>

<script type="text/javascript">
    $(document).ready(function() {
        var data_get_map = {'frm_GeneralSettings':"/api/caddy/General/get"};
        mapDataToFormUI(data_get_map).done(function(data){
            // console.log("Fetched data:", data); // Log the fetched data
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

            // Populate Trusted Proxies dropdown
            var accesslistSelect = $('#caddy\\.general\\.accesslist');
            accesslistSelect.empty(); // Clear existing options
            $.each(generalSettings.accesslist, function(key, option) {
                accesslistSelect.append(new Option(option.value, key, false, option.selected === 1));
            });

            // Refresh selectpicker for these dropdowns
            $('.selectpicker').selectpicker('refresh');

            // Function to show alerts with Bootstrap modals for user feedback
            function showAlert(message, title = "Configuration Validation Failed") {
                if ($("#alertModal").length === 0) {
                    $("body").append(
                        `<div class="modal fade" id="alertModal" tabindex="-1" role="dialog">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">${title}</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">${message}</div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>`
                    );
                } else {
                    $("#alertModal .modal-title").text(title);
                    $("#alertModal .modal-body").html(message);
                }
                $("#alertModal").modal('show');
            }

            // Modify the Reconfigure button to include validation in onPreAction
            $("#reconfigureAct").SimpleActionButton({
                onPreAction: function() {
                    const dfObj = $.Deferred();

                    // Step 1: Save the form data
                    saveFormToEndpoint("/api/caddy/general/set", 'frm_GeneralSettings', function() {
                        // Form save successful, proceed to validation
                        $.ajax({
                            url: "/api/caddy/service/validate",
                            type: "GET",
                            dataType: "json",
                            success: function(data) {
                                if (data && data['status'].toLowerCase() === 'ok') {
                                    // If configuration is valid, resolve the Deferred object to proceed
                                    dfObj.resolve();
                                } else {
                                    // If configuration is invalid, show alert and reject the Deferred object
                                    showAlert(data['message']);
                                    dfObj.reject();
                                }
                            },
                            error: function(xhr, status, error) {
                                // On AJAX error, show alert and reject the Deferred object
                                showAlert("Validation request failed: " + error);
                                dfObj.reject();
                            }
                        });
                    }, function() {
                        // Form save failed, reject the Deferred object
                        showAlert("Failed to save configuration.");
                        dfObj.reject();
                    });

                    return dfObj.promise();
                },
                onAction: function(data, status) {
                    if (status === "success" && data && data['status'].toLowerCase() === 'ok') {
                        // Update only the service control UI for 'caddy'
                        updateServiceControlUI('caddy');
                    } else {
                        console.error("Action was not successful or an error occurred:", data);
                    }
                }
            });

            // Initialize the service control UI for 'caddy'
            updateServiceControlUI('caddy');

        });
    });
</script>
