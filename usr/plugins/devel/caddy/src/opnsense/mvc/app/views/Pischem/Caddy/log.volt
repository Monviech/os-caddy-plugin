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
ul.pagination {
    display: none;
}

#grid-log .timestamp-column,
#grid-log th[data-column-id="timestamp"],
#grid-log td:nth-child(1) { /* Assuming timestamp is the first column */
    width: 150px;
    min-width: 150px;
    max-width: 150px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
</style>

<script>
$(document).ready(function() {
    var apiEndpoint = '/api/caddy/log/get';

    var grid = $("#grid-log").bootgrid({
        ajax: true,
        url: apiEndpoint,
        rowCount: [10, 25, 50, 100, 250, 500, 1000],
        searchSettings: {
            delay: 500,
            characters: 3
        },
        requestHandler: function(request) {
            var params = {
                current: request.current,
                rowCount: request.rowCount,
                sort: request.sort,
                searchPhrase: request.searchPhrase
            };
            return params;
        },
        responseHandler: function(response) {
            return response;
        },
        formatters: {
            "timestamp": function(column, row) {
                return new Date(row.ts * 1000).toLocaleString();
            },
            "level": function(column, row) {
                return row.level;
            },
            "message": function(column, row) {
                var message = row.msg; // Start with the message

                // Loop through all properties of the row
                for (var key in row) {
                    if (row.hasOwnProperty(key) && key !== 'msg' && key !== 'ts' && key !== 'level') {
                        // Append each property to the message
                        message += ', ' + key + ': ' + JSON.stringify(row[key]);
                    }
                }
                return message;
            }
        },
    });
});
</script>

<div class="content-box">
    <div class="table-responsive">
        <div class="content-box-header">
            <div class="box-title">
            </div>
        </div>
        <table id="grid-log" class="table table-condensed table-hover table-striped">
            <thead>
                <tr>
                    <th data-column-id="timestamp" data-formatter="timestamp" data-sortable="true">Timestamp</th>
                    <th data-column-id="level" data-formatter="level" data-sortable="true">Severity</th>
                    <th data-column-id="message" data-formatter="message" data-sortable="true">Message</th>
                </tr>
            </thead>
        </table>
    </div>
</div>
