using CodeCooker.Models;
using CodeCooker.Models.ClassDiagram;
using CodeCooker.Models.DiagramGeneric;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace CodeCooker.Controllers
{
    public class FileController : Controller
    {

        public async Task<ActionResult> DownloadFile(CancellationToken cancelationToken, string fileID)
        {
            ViewBag.userLogedIn = User.Identity.IsAuthenticated;
            Models.GoogleDrive.DriveService service = new Models.GoogleDrive.DriveService();
            bool authenticated = await service.CreateService(cancelationToken, this);
            if (authenticated)
            {
                Models.GoogleDrive.FileManipulator files = new Models.GoogleDrive.FileManipulator(service);
                Models.GoogleDrive.File driveFile = await files.DownloadFile(fileID);

                Tuple<string, Models.ClassDiagram.Version> convertedModel =
                    CodeCooker.Models.Conversion.Converter.convertModelToLatestVersion(driveFile.Content);

                ViewBag.document = convertedModel.Item1;
                ViewBag.docmentName = driveFile.Name;

                if (convertedModel.Item2 == Configuration.Configuration.FrontendVersion)
                {   
                    ViewBag.modelCreatedWithOlderVersion = false;
                }
                else
                {
                    ViewBag.modelCreatedWithOlderVersion = true;
                }
            }
            return View();
        }

        public async Task<ActionResult> UploadFile(CancellationToken cancellationToken)
        {
            string model;
            using (var reader = new StreamReader(Request.InputStream))
            {
                model = reader.ReadToEnd();
            }
            DocumentModelForSave docModel = null;
            try
            {
                docModel = DiagramModelParser.ParseForSave(model);
            }
            catch (Exception e)
            {
                ViewBag.sucess = false;
                ViewBag.reason = "Upload was rejected failed to parse.";
                return View();
            }
            CodeCooker.Models.GoogleDrive.DriveService service = new Models.GoogleDrive.DriveService();
            bool sucess = await service.CreateService(cancellationToken, this);
            ViewBag.sucess = false;
            if (sucess)
            {
                CodeCooker.Models.GoogleDrive.FileManipulator driveFiles = new Models.GoogleDrive.FileManipulator(service);
                driveFiles.CreateOrOverwrite(docModel.Name, model);
                ViewBag.sucess = true;
            }
            else
                ViewBag.reason = "Upload was not saved, could not contact google drive";
            return View();
        }


    }
}
