using Google.Apis.Drive.v2.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.GoogleDrive
{
    public class ProjectManipulator
    {

        private DriveService _service;
        public ProjectManipulator(DriveService service)
        {
            this._service = service;
        }

        public ProjectModel CreateProject(string name)
        {
            return new ProjectModel(name, new ProjectList());
        }

        public ProjectList GetProjectList()
        {
            string codeCookerFolderID = "";

            if (this.getCodeCookerFolderID(out codeCookerFolderID))
            {
                Google.Apis.Drive.v2.FilesResource.ListRequest req = this._service.Service.Files.List();
                req.Q = String.Format("title contains '.coc' and '{0}' in parents", codeCookerFolderID);
                FileList projectFiles = req.Execute();
                ProjectList projectList = new ProjectList();

                foreach (var projectFile in projectFiles.Items) 
                {
                    projectList.addProject(projectFile.Id, projectFile.Title);
                }
                return projectList;
            }
            else
            {
                CreateCodeCookerFolder();
                return new ProjectList();
            }
        }

        private bool getCodeCookerFolderID(out string id)
        {
            Google.Apis.Drive.v2.FilesResource.ListRequest req = this._service.Service.Files.List();
            req.Q = "mimeType = 'application/vnd.google-apps.folder' and title = 'CodeCookerProjects'";
            FileList CodeCookerFolerResult = req.Execute();

            if (CodeCookerFolerResult.Items.Count > 0) // should we check if our query returned more than 1 result? It shouldnt but....
            {
                var folder = CodeCookerFolerResult.Items[0];
                id = folder.Id;
                return true; 
            }
            else
            {
                id = "";
                return false;
            }
        }

        private void CreateCodeCookerFolder()
        {

        }
    }
}