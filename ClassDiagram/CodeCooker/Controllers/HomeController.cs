using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;

using Google.Apis.Sample.MVC.Models;
using Google.Apis.Auth.OAuth2.Mvc;
using Google.Apis.Download;
using Google.Apis.Drive.v2;
using Google.Apis.Services;
using Google.Apis.Sample.MVC.Controllers;
using CodeCooker.Models;

namespace CodeCooker.Controllers
{
    public class HomeController : Controller
    {
        public async Task<ActionResult> Index(CancellationToken cancellationToken)
        {
            ViewBag.Message = "Code Cooker";
            ViewBag.AuthenticatedUser = User.Identity.IsAuthenticated;
            if (ViewBag.AuthenticatedUser)
            {
                var result = await new AuthorizationCodeMvcApp(this, new AppAuthFlowMetadata()).
                    AuthorizeAsync(cancellationToken);

                if (result.Credential == null)
                    return new RedirectResult(result.RedirectUri);

                var driveService = new DriveService(new BaseClientService.Initializer
                {
                    HttpClientInitializer = result.Credential,
                    ApplicationName = "Code Cooker"
                });

                var listReq = driveService.Files.List();
                listReq.Fields = "items/title,items/id,items/createdDate,items/downloadUrl,items/exportLinks";
                var list = await listReq.ExecuteAsync();
                var items =
                    (from file in list.Items
                     select new FileModel
                     {
                         Title = file.Title,
                         Id = file.Id,
                         CreatedDate = file.CreatedDate,
                         DownloadUrl = file.DownloadUrl ??
                                                   (file.ExportLinks != null ? file.ExportLinks["application/pdf"] : null),
                     }).OrderBy(f => f.Title).ToList();
                return View(items);
            }


            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your app description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
           
            return View();
        }

        [Authorize]
        public async Task<ActionResult> DriveAsync(CancellationToken cancellationToken)
        {
            ViewBag.Message = "Your drive page.";

            var result = await new AuthorizationCodeMvcApp(this, new AppAuthFlowMetadata()).
                    AuthorizeAsync(cancellationToken);

            if (result.Credential == null)
                return new RedirectResult(result.RedirectUri);

            var driveService = new DriveService(new BaseClientService.Initializer
            {
                HttpClientInitializer = result.Credential,
                ApplicationName = "ASP.NET Google APIs MVC Sample"
            });

            var listReq = driveService.Files.List();
            listReq.Fields = "items/title,items/id,items/createdDate,items/downloadUrl,items/exportLinks";
            var list = await listReq.ExecuteAsync();
            var items =
                (from file in list.Items
                 select new FileModel
                 {
                     Title = file.Title,
                     Id = file.Id,
                     CreatedDate = file.CreatedDate,
                     DownloadUrl = file.DownloadUrl ??
                                               (file.ExportLinks != null ? file.ExportLinks["application/pdf"] : null),
                 }).OrderBy(f => f.Title).ToList();
            return View(items);
        }
    }
}
