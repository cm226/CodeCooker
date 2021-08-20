using CodeCooker.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CodeCooker.Controllers
{
    public class ProjectTemplatesController : Controller
    {

        public ActionResult Download(string templateName)
        {
            string file = string.Format("{0}\\{1}.coc",SpecialDirectorys.ProjectTemplates,templateName);
            ViewBag.documentNotFound = false;
            if (System.IO.File.Exists(file))
            {
                string[] fileContent = System.IO.File.ReadAllLines(file);
                //DocumentModel dom = Models.ClassDiagram.DiagramModelParser.Parse(String.Join(Environment.NewLine, fileContent));

                ViewBag.document = String.Join(Environment.NewLine, fileContent);
                ViewBag.docmentName = "templateName";
                ViewBag.modelCreatedWithOlderVersion = false;
            }
            else
                ViewBag.modelCreatedWithOlderVersion = true;

            return View("~\\Views\\File\\DownloadFile.cshtml");
        }

    }
}
