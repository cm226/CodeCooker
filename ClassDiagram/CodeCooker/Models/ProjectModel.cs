using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public class ProjectModel
    {
        public ProjectList Files { get; set; }
        public string ProjectName {get; set;}

        public ProjectModel():this("", new ProjectList())
        {
        }

        public ProjectModel(string projectName, ProjectList files)
        {
            this.Files = files;
            this.ProjectName = projectName;
        }
    }
}