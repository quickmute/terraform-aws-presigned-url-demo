(function myScopeWrapper($) {
    $(function onDocReady() {
        alert('Welcome');
        
        //fileButton triggers click on the File Input field
        // we could have skipped fileButton and used the built-in
        // "Choose File" button that comes with File Input field
        // if we wanted to unhide that Input field
        $('#fileButton').on('click', function () {
            $('#fileInput').trigger('click');
        });

        // when a file is chose, we trigger to get pre-signed URL
        $('#fileInput').change(handleRequestClick);

        // this is AJAX method of uploading
        // Work In Progress
        $('#uploadButton').click(handleUploadClick);

        if (!_config.api.invokeUrl) {
            $('#noApiMessage').show();
        }
    });
    //////////////////////////////////////////
    // AJAX method of uploading
    function handleUploadClick() {
        var filename = $('#fileInput').val();
        var target = $('#target').val();
        uploadPresignedURL(filename, target);
    }

    function uploadPresignedURL(filename_var, target_var) {
        const target_json = JSON.parse(target_var);
        const url = target_json['url'];
        const fields = target_json['fields'];
        const formData = new FormData();
        for (var element in fields) {
            formData.append(element, fields[element]);
        }
        formData.append("file", filename_var);
        formData.delete("content-type")
        
        $.ajax({
            type: 'POST',
            url: url,
            headers: {
                'Access-Control-Allow-Origin': '*'
            },
            data: formData,
            cache: false,
            processData: false,
            success: displayUpdate,
            error: parseBadOutput
        });
    }

    function parseBadOutput(result){
        for (var element in result) {
            displayUpdate(element + ": " + result[element]);
        }
    }
    //////////////////////////////////////////

    //////////////////////////////////////////
    // getting Presigned URL POST
    function handleRequestClick() {
        var fileInput = $('#fileInput').val();
        var filename = just_file_name(fileInput);
        var filename_type = fileInput.type
        var argument = {
            'filename' : filename,
            'filename_type' : filename_type
        }
        get_api_response(filename);
    }

    //just want the filename
    function just_file_name(str) {
        return str.split('\\').pop().split('/').pop();
    }

    function get_api_response(argument_var) {
        $.ajax({
            method: 'POST',
            url: _config.api.invokeUrl + '/example',
            headers: {

            },
            data: JSON.stringify({
                argument: argument_var
            }),
            contentType: 'application/json',
            success: completeRequest,
            error: displayUpdate
        });
    }

    function completeRequest(result) {
        const response = JSON.parse(result.Response);
        displayUpdate("url : " + response['url']);
        //get all fields
        //https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-presigned-urls.html
        for (var element in response['fields']) {
            displayUpdate(element + ": " + response['fields'][element]);
        }
        console.log('Response received from API: ', result);
        $('#uploadButton').show();
        $('#lonesubmit').show();
        $("#target").val(result.Response);
        populateForm();
    }

    function populateForm(){
        var filename = $('#fileInput').val();
        var target = $('#target').val();
        const target_json = JSON.parse(target);
        const url = target_json['url'];
        const fields = target_json['fields'];
        $('#main').attr('action',url);
        $('#key').val(fields['key']);
        $('#acl').val(fields['acl']);
        //$('#Content-Type').val(fields['Content-Type']);
        $('#X-Amz-Credential').val(fields['x-amz-credential']);
        $('#X-Amz-Algorithm').val(fields['x-amz-algorithm']);
        $('#X-Amz-Date').val(fields['x-amz-date']);
        $('#Policy').val(fields['policy']);
        $('#X-Amz-Signature').val(fields['x-amz-signature']);
        $('#X-Amz-Security-Token').val(fields['x-amz-security-token']);
        //$('#success_action_redirect').val(url.concat("success.html"));
    }
    //////////////////////////////////////////
    function displayUpdate(text) {
        $('#updates').append($('<li>' + text + '</li>'));
    }

}(jQuery));
