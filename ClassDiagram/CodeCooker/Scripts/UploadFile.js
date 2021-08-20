window.Interface.File = {};

(function(namespace) 
{
	namespace.uploadFile = function(data, location, progressListener)
	{
	  var xhr = new XMLHttpRequest();

	  /* event listners  if hit a problem with upload size then set mime type too multipart/form-data*/
	  xhr.upload.addEventListener("progress", progressListener.uploadProgress, false);
	  xhr.addEventListener("load", progressListener.uploadComplete, false); //this.responseText
	  xhr.addEventListener("error", progressListener.uploadFailed, false);
	  xhr.addEventListener("abort", progressListener.uploadCanceled, false);
	  /* Be sure to change the url below to the url of your upload server side script */
	  xhr.open("POST", location);
	  xhr.send(data);
	}

})(window.Interface.File);