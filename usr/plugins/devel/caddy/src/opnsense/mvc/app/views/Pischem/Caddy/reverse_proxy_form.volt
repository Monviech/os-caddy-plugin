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
    <h1 id="formHeadline">
        <!-- Dynamically popualted with Javascript -->
    </h1>
    {{ partial("layout_partials/base_form", ['fields': reverseProxyForm, 'id': 'frm_ReverseProxy']) }}
    <div id="formErrors" style="color: red;"></div> <!-- Container for general form errors -->
</div>

<div style="margin-top: 20px; width: 100%; background-color: white; padding: 5px; border: 1px solid #ddd;">
    <!-- Save button -->
    <button id="reverseProxySaveAct" class="btn btn-primary" type="button" style="margin-left: 4px;"><b>Save</b></button>
    <!-- Cancel button -->
    <button id="reverseProxyCancelAct" class="btn btn-secondary" type="button" style="margin-left: 4px;"><b>Cancel</b></button>
</div>

<script type="text/javascript">
    // Function to retrieve a parameter from the URL query string
    function getQueryVariable(variable) {
        var query = window.location.search.substring(1);
        var vars = query.split("&");
        for (var i = 0; i < vars.length; i++) {
            var pair = vars[i].split("=");
            if (pair[0] === variable) {
                return decodeURIComponent(pair[1].replace(/\+/g, " "));
            }
        }
        return false;
    }

    $(document).ready(function() {
        var uuid = getQueryVariable("uuid");

        if (uuid) {
            $('#formHeadline').text('Edit Reverse Proxy Entry');
            // Fetch and populate data for editing based on UUID
            fetch('/api/caddy/ReverseProxy/get/' + uuid)
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    var entry = data.reverse[uuid];
                    if (entry) {
                        $('#caddy\\.reverseproxy\\.reverse\\.Enabled').prop('checked', entry.Enabled === "1");
                        $('#caddy\\.reverseproxy\\.reverse\\.FromDomain').val(entry.FromDomain);
                        $('#caddy\\.reverseproxy\\.reverse\\.FromPort').val(entry.FromPort);
                        $('#caddy\\.reverseproxy\\.reverse\\.ToDomain').val(entry.ToDomain);
                        $('#caddy\\.reverseproxy\\.reverse\\.ToPort').val(entry.ToPort);
                        $('#caddy\\.reverseproxy\\.reverse\\.Description').val(entry.Description);
                        $('#caddy\\.reverseproxy\\.reverse\\.DnsChallenge').prop('checked', entry.DnsChallenge === "1");
                    }
                })
                .catch(function(error) {
                    console.error('Error fetching reverse proxy entry:', error);
                });
        } else {
            // No UUID means it's either Add or Clone
            var isClone = window.location.search.indexOf('Enabled') > -1;
            if (isClone) {
                $('#formHeadline').text('Clone Reverse Proxy Entry');
            } else {
                $('#formHeadline').text('Add Reverse Proxy Entry');
            }

            // Common logic for Add and Clone (populate fields if query params exist)
            function populateField(id, value) {
                if (value !== false) {
                    $(id).val(value);
                } else {
                    $(id).val(''); // Clear the field
                }
            }

            function populateCheckboxField(id, value) {
                $(id).prop('checked', value === "1");
            }

            populateCheckboxField('#caddy\\.reverseproxy\\.reverse\\.Enabled', getQueryVariable("Enabled"));
            populateField('#caddy\\.reverseproxy\\.reverse\\.FromDomain', getQueryVariable("FromDomain"));
            populateField('#caddy\\.reverseproxy\\.reverse\\.FromPort', getQueryVariable("FromPort"));
            populateField('#caddy\\.reverseproxy\\.reverse\\.ToDomain', getQueryVariable("ToDomain"));
            populateField('#caddy\\.reverseproxy\\.reverse\\.ToPort', getQueryVariable("ToPort"));
            populateField('#caddy\\.reverseproxy\\.reverse\\.Description', getQueryVariable("Description"));
            populateCheckboxField('#caddy\\.reverseproxy\\.reverse\\.DnsChallenge', getQueryVariable("DnsChallenge"));
        }

        // Event listener for the Save button
        $('#reverseProxySaveAct').click(function() {
            var formData = {};

            // Manually collect each field value
            formData['Enabled'] = $('#caddy\\.reverseproxy\\.reverse\\.Enabled').is(':checked') ? "1" : "0";
            formData['FromDomain'] = $('#caddy\\.reverseproxy\\.reverse\\.FromDomain').val();
            formData['FromPort'] = $('#caddy\\.reverseproxy\\.reverse\\.FromPort').val();
            formData['ToDomain'] = $('#caddy\\.reverseproxy\\.reverse\\.ToDomain').val();
            formData['ToPort'] = $('#caddy\\.reverseproxy\\.reverse\\.ToPort').val();
            formData['Description'] = $('#caddy\\.reverseproxy\\.reverse\\.Description').val();
            formData['DnsChallenge'] = $('#caddy\\.reverseproxy\\.reverse\\.DnsChallenge').is(':checked') ? "1" : "0";

            // console.log("Structured Form Data:", formData);

            // Determine the correct API endpoint and method
            var apiEndpoint = '/api/caddy/ReverseProxy/';
            var apiMethod = 'POST';
            var isEdit = uuid !== false;

            if (isEdit) {
                // If editing, use the PUT method and append the UUID to the endpoint
                apiEndpoint += 'set/' + uuid;
                apiMethod = 'PUT';
            } else {
                // If adding, use the POST method and the 'add' endpoint
                apiEndpoint += 'add';
                apiMethod = 'POST';
            }

        // AJAX call to add or edit an entry
        $.ajax({
            url: apiEndpoint,
            method: apiMethod,
            contentType: 'application/json',
            data: JSON.stringify({ reverse: formData }),
            success: function(data) {
                if (data.result === "saved") {
                    // Handle success (e.g., clear form, show success message, redirect)
                    window.location.href = '/ui/caddy/reverse_proxy'; // Redirect on success
                } else {
                    // Clear previous errors
                    $('#formErrors').empty();
                    $('.input-error-message').remove();

                    // Display field-specific validation errors
                    if (data.validations) {
                        for (var field in data.validations) {
                            var errorMessage = data.validations[field];
                            var fieldName = field.split('.').pop(); // Simplify field name
                            var inputSelector = '#caddy\\.reverseproxy\\.reverse\\.' + fieldName;
                            $(inputSelector).after('<span class="input-error-message" style="color: red;">' + errorMessage + '</span>');
                        }
                    }
                }
            },
            error: function(xhr, status, errorThrown) {
                // Clear previous errors
                $('#formErrors').empty();
                $('.input-error-message').remove();

                // Display a general error message
                $('#formErrors').html('<div>An unexpected error occurred: ' + errorThrown + '</div>');
            }
        });
    });

        // Event listener for the Cancel button
            $('#reverseProxyCancelAct').click(function() {
            window.location.href = '/ui/caddy/reverse_proxy';
        });
    });
</script>
