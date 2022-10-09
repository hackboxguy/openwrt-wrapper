module("luci.controller.awsiot.awsuimodule", package.seeall)
function index()
	entry({"admin", "awsuimodule" }, firstchild(), "AWS-IoT", 60).dependent=false
        entry({"admin", "awsuimodule", "aws_tab_uploadcert"}, call("action_upload_device_cert"), "Upload Device Cert", 1)
        entry({"admin", "awsuimodule", "aws_tab_uploadkey"},  call("action_upload_device_key"), "Upload Device Key", 2)
	entry({"admin", "awsuimodule", "aws_tab_logs"},    call("action_awsiotlog"), "Service Log", 3)
	entry({"admin", "awsuimodule", "aws_tab_logs_startup"},    call("action_awsiotlog_startup"), "Service Startup Log", 4)
        entry({"admin", "awsuimodule", "aws_tab_cbi"},     cbi("awsiot_cbi/awsiot-srvice-settings"), "Service Settings", 5)
        
	--entry({"admin", "awsuimodule", "aws_tab_reset"},   call("action_reboot"), "Reboot", 5)
	--entry({"admin", "awsuimodule", "aws_tab_connect"}, template("awsiot_view/connectivity_tab"), "Connect", 1)
	--entry({"admin", "awsuimodule", "aws_tab_demoapp"}, template("awsiot_view/demoapp_tab"), "DemoApp", 2)
	--entry({"admin", "awsuimodule", "aws_tab_logs"},    call("action_awsiotlog"), "Logs", 3)
        --entry({"admin", "awsuimodule", "aws_tab_cbi"},     cbi("awsiot_cbi/cbi_test"), "Cbi-Test", 5) --cbi_test.lua
        --entry({"admin", "awsuimodule", "aws_tab_uploadcert"}, call("action_upload_device_cert"), "Upload Device Certificate", 6)
        --entry({"admin", "awsuimodule", "aws_tab_uploadkey"},  call("action_upload_device_key"), "Upload Device Key", 6)
end

function action_awsiotlog()
    local awsiotlog = luci.sys.exec("cat /tmp/aws-iot-pubsub-agent.log")
    luci.template.render("awsiot_view/awsiotlog", {awsiotlog=awsiotlog})
end

function action_awsiotlog_startup()
    local awsiotlogst = luci.sys.exec("cat /tmp/aws-iot-pubsub-agent.startuplog")
    luci.template.render("awsiot_view/awsiotlog-startup", {awsiotlogst=awsiotlogst})
end

function action_reboot()
    --luci.http.prepare_content("text/plain")
    --luci.http.write("Haha, rebooting now...")
    --luci.template.render("awsiot_view/rebootmessage") --,{rebooterr=rebooterr})
    --luci.sys.reboot()
luci.template.render("admin_system/applyreboot", {
			msg   = luci.i18n.translate("The system rebooting.. Wait a few minutes before you try to reconnect."),
			--addr  = (#keep > 0) and "192.168.1.1" or nil
		})
    luci.sys.reboot()
end

function action_upload_device_cert()
	action_uploadfile("awsiot_view/upload-device-cert","/root/certificate.pem")
end

function action_upload_device_key()
	action_uploadfile("awsiot_view/upload-device-key","/root/private.pem.key")
end

function action_uploadfile(uploader_view,file_loc)
   local error = nil	
   --file_loc = "/tmp/certs/"
   tmpfile = file_loc --"/tmp/certs.img"
   input_field = "input-name"
   file_name = "default name"
   local values = luci.http.formvalue()
   local ul = values[input_field]
   if ul ~= '' and ul ~= nil then
	local file
	luci.http.setfilehandler(
		function(meta, chunk, eof)
			if not nixio.fs.access(tmpfile) and not file and chunk and #chunk > 0 then
				file = io.open(tmpfile, "w")
			end
			if file and chunk then
				file:write(chunk)
			end
			if file and eof then
				file:close()
			end
		end
	)
	error = nil --checkFile(tmpfile)
   end
   --luci.template.render("awsiot_view/uploader", {error=error})
   luci.template.render(uploader_view, {error=error})
end

function setFileHandler(location, input_name, file_name)
	  local fs = require("nixio.fs")
	  local fp
	  luci.http.setfilehandler(
		 function(meta, chunk, eof)
		 if not fp then
			--make sure the field name is the one we want
			if meta and meta.name == input_name then
			   --use the file name if specified
			   if file_name ~= nil then
				  fp = io.open(location .. file_name, "w")
			   else
				  fp = io.open(location .. meta.file, "w")
			   end
			end
		 end
		 --actually do the uploading.
		 if chunk then
			fp:write(chunk)
		 end
		 if eof then
			fp:close()
		 end
		 end)
end
