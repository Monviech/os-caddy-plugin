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


<style>
    #reverseProxyGrid th:last-child,
    #reverseProxyGrid td:last-child {
        text-align: right;
    }
</style>

<div style="background-color: white; padding: 10px; border: 1px solid #ddd;">
    <h1>Reverse Proxy</h1>
    <div style="display: block;"> <!-- Common container -->
        <table id="reverseProxyGrid" class="table table-condensed table-hover table-striped">
            <thead>
                <tr>
                    <th data-column-id="enabled">Enabled</th>
                    <th data-column-id="DnsChallenge">DNS-01</th>
                    <th data-column-id="fromDomain">From Domain</th>
                    <th data-column-id="fromPort">From Port</th>
                    <th data-column-id="toDomain">To Domain</th>
                    <th data-column-id="toPort">To Port</th>
                    <th data-column-id="description">Description</th>
                    <th data-column-id="commands" style="text-align: right;">Commands</th>
                </tr>
            </thead>
            <tbody>
            <!-- Dynamically generated rows will be inserted here -->
            </tbody>
        </table>

        <div style="text-align: right; margin-top: 10px; margin-right: 55px;">
            <button id="addReverseProxyBtn" type="button" class="btn btn-xs btn-primary">
                <span class="fa fa-fw fa-plus"></span>
            </button>
        </div>
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
    document.addEventListener("DOMContentLoaded", function() {
        // Fetch reverse proxy entries on page load
        fetch('/api/caddy/ReverseProxy/get')
            .then(response => response.json())
            .then(data => {
                const reverseProxies = data.reverse;
                const tbody = document.querySelector('#reverseProxyGrid tbody');
                tbody.innerHTML = ''; // Clear existing rows

                // Iterate through the reverse proxy entries and create table rows
                Object.keys(reverseProxies).forEach(uuid => {
                    const entry = reverseProxies[uuid];
                    const row = tbody.insertRow();

                    // Enabled checkbox
                    const enabledCell = row.insertCell();
                    const enabledCheckbox = document.createElement('input');
                    enabledCheckbox.type = 'checkbox';
                    enabledCheckbox.checked = entry.Enabled === "1";
                    enabledCheckbox.disabled = true;
                    enabledCell.appendChild(enabledCheckbox);

                    // DNS-01 checkbox
                    const dnsChallengeCell = row.insertCell();
                    const dnsChallengeCheckbox = document.createElement('input');
                    dnsChallengeCheckbox.type = 'checkbox';
                    dnsChallengeCheckbox.checked = entry.DnsChallenge === "1";
                    dnsChallengeCheckbox.disabled = true; // Making it read-only
                    dnsChallengeCell.appendChild(dnsChallengeCheckbox);

                    row.insertCell().textContent = entry.FromDomain;
                    row.insertCell().textContent = entry.FromPort;
                    row.insertCell().textContent = entry.ToDomain;
                    row.insertCell().textContent = entry.ToPort;
                    const descriptionCell = row.insertCell();
                    descriptionCell.textContent = entry.Description;

                    const commandsCell = row.insertCell();
                    commandsCell.innerHTML = `
                        <button type="button" class="btn btn-xs btn-default btn-secondary command-edit" title="Edit" data-row-id="${uuid}">
                            <span class="fa fa-pencil"></span>
                        </button>
                        <button type="button" class="btn btn-xs btn-default btn-secondary command-clone" title="Clone" data-row-id="${uuid}">
                            <span class="fa fa-clone"></span>
                        </button>
                        <button type="button" class="btn btn-xs btn-danger command-delete" title="Delete" data-row-id="${uuid}">
                            <span class="fa fa-trash-o"></span>
                        </button>
                    `;

                    // Attach the event listeners to the buttons
                    commandsCell.querySelector('.command-edit').addEventListener('click', function(event) {
                        editEntry(event.currentTarget.dataset.rowId);
                    });
                    commandsCell.querySelector('.command-clone').addEventListener('click', function(event) {
                        cloneEntry(event.currentTarget.dataset.rowId);
                    });
                    commandsCell.querySelector('.command-delete').addEventListener('click', function(event) {
                        deleteEntry(event.currentTarget.dataset.rowId);
                    });
                });
            })
            .catch(error => console.error('Error loading reverse proxy entries:', error));

        // Function to edit an entry
        function editEntry(uuid) {
            // Redirect to the reverse proxy form with the UUID in the query string
            window.location.href = `/ui/caddy/reverse_proxy_form?uuid=${uuid}`;
        }

        // Function to clone an entry
        function cloneEntry(uuid) {
            console.log('Cloning entry', uuid);

            fetch('/api/caddy/ReverseProxy/get/' + uuid)
                .then(response => response.json())
                .then(data => {
                    const entry = data.reverse[uuid];

                    // Construct the query string with the entry data but without the UUID
                    const queryString = Object.keys(entry)
                        .filter(key => key !== 'UUID') // Exclude the UUID
                        .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(entry[key])}`)
                        .join('&');

                    // Redirect to the reverse proxy form with the cloned data in the query string
                    window.location.href = `/ui/caddy/reverse_proxy_form?${queryString}`;
                })
                .catch(error => console.error('Error cloning entry:', error));
        }

        // Function to delete an entry
        function deleteEntry(uuid) {
            console.log('Deleting entry', uuid);
            if (confirm('Are you sure you want to delete this entry?')) {
                $.ajax({
                    url: '/api/caddy/ReverseProxy/del/' + uuid, // Include UUID in the URL
                    method: 'POST',
                    contentType: 'application/json',
                    success: function(data) {
                        console.log('Delete response:', data);
                        // Handle the response
                    },
                    error: function(xhr, status, error) {
                        console.error('Error deleting entry:', error);
                        // Handle the error
                    }
                });
                // action to run after successful save, for example reconfigure service.
                location.reload();
            }
        }

        // Event listener for the Add Reverse Proxy Button
        document.getElementById('addReverseProxyBtn').addEventListener('click', function() {
            window.location.href = '/ui/caddy/reverse_proxy_form';
        });

        // Initialize the Apply button using SimpleActionButton
        $("#reconfigureAct").SimpleActionButton();

    });
</script>
