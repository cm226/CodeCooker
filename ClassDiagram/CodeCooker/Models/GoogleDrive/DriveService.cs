using Google.Apis.Auth.OAuth2.Mvc;
using Google.Apis.Sample.MVC.Controllers;
using Google.Apis.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace CodeCooker.Models.GoogleDrive
{
    public class DriveService
    {
        private Google.Apis.Drive.v2.DriveService service;
        public Google.Apis.Drive.v2.DriveService Service 
        {
            get 
            {
                if (this.service != null)
                    return this.service;
                else
                    throw new NullReferenceException("the async method CreateService must be called before accessing the service");
            }
        }

        public async Task<bool> CreateService(CancellationToken cancellationToken, Controller controller)
        {
                var result = await new AuthorizationCodeMvcApp(controller, new AppAuthFlowMetadata()).
                    AuthorizeAsync(cancellationToken);

                if (result.Credential == null)
                {
                    controller.Response.Redirect(result.RedirectUri);
                    return false;
                }

                this.service = new Google.Apis.Drive.v2.DriveService(new BaseClientService.Initializer
                {
                    HttpClientInitializer = result.Credential,
                    ApplicationName = "Code Cooker"
                });
                return true;
        }
    }
}