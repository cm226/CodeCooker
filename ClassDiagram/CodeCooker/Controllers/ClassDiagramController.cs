using CodeCooker.CodeGeneration;
using CodeCooker.Hubs;
using CodeCooker.Models;
using CodeCooker.Models.ClassDiagram;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Script.Serialization;

namespace CodeCooker.Controllers
{
    public class ClassDiagramController : Controller
    {
        public class DriveState
        {
            public string action { get; set; }
            public string parentId { get; set; }
            public string[] ids { get; set; }
        }
        //
        // GET: /ClassDiagram/

        public ActionResult Index()
        {
            ViewBag.userLogedIn = User.Identity.IsAuthenticated;
            UsersContext context = new UsersContext();
            var UserThemeQuery = from theme in context.Themes
                                 join user in context.UserProfiles on theme.ThemeID equals user.ThemeID
                                 where user.UserName == this.User.Identity.Name
                                 select theme;
            var userTheme = UserThemeQuery.ToList();
            if (userTheme.Count > 0)
                ViewBag.themeID = userTheme[0].ThemeID;
            else
                ViewBag.themeID = 1; // default theme

            return View();
        }

        public ActionResult Open(CancellationToken cancelationToken, string fileID)
        {
            ViewBag.userLogedIn = User.Identity.IsAuthenticated;
            if (ViewBag.userLogedIn)
            {
                UsersContext context = new UsersContext();
                var UserThemeQuery = from theme in context.Themes
                                  join user in context.UserProfiles on theme.ThemeID equals user.ThemeID
                                  where user.UserName == this.User.Identity.Name
                                  select theme;
                var userTheme = UserThemeQuery.ToList();
                
                if (userTheme.Count > 0)
                    ViewBag.themeID = userTheme[0].ThemeID;
                else
                    ViewBag.themeID = 1; // default theme

                ViewBag.documentID = fileID;
                    
            }
            else
            {
                ViewBag.themeID = 1; // default theme
            }
            return View("~\\Views\\ClassDiagram\\index.cshtml");
        }

        public ActionResult GDriveOpen(string state, string code)
        {
            DriveState driveState = new DriveState();

            if (!string.IsNullOrEmpty(state))
            {
                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                driveState = jsonSerializer.Deserialize<DriveState>(state);
            }

            if (driveState.action == "open")
                return OpenWith(driveState);
            else
                return CreateNew(driveState);
        }

        private ActionResult OpenWith(DriveState state)
        {
            return View();
        }

        private ActionResult CreateNew(DriveState state)
        {
            return View();
        }

        public ActionResult Help()
        {
            return View();
        }

        public ActionResult DownloadCode(string language)
        {
            string model;
            using (var reader = new StreamReader(Request.InputStream))
            {
                model = reader.ReadToEnd();
            }
            DocumentModel docModel =  DiagramModelParser.Parse(model);
            CodeGenerator.Language langauge = (CodeGenerator.Language)Enum.Parse(typeof(CodeGenerator.Language), language, true);
            CodeGenerator generator = new CodeGenerator(docModel);
            Packager codePackager = new Packager();
            try
            {
                generator.GenerateCode(langauge, User.Identity.Name, codePackager);
                ViewBag.downloadURL = codePackager.downloadURL;
            }
            catch(CodeDom.Exceptions.CodeDomException e)
            {
                ViewBag.Error = e.Message;
            }
            return View();
        }

        public ActionResult Sandbox()
        {
            ViewBag.document = new DocumentModel(); // pretend we are not openeing a new document so the user dosent see the file name dialog
            ViewBag.themeID = 1;
            return View();
        }


    }
}
