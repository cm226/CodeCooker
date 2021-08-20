using CodeCooker.Models.ClassDiagram;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace CodeCooker.Models
{
    public class DocumentModel
    {
        public string Name { get; set; }

        [JsonIgnore]
        public CodeCooker.Models.ClassDiagram.Version VersionModel;

        private string version;
        public string Version
        {
            get{return this.version;}
            set
            {
                this.version = value;
                this.VersionModel = new ClassDiagram.Version(value);
            }
        }
        public List<ClassModel> classList { get; set; }
        public List<ArrowModel> arrowList { get; set; }
        public List<InterfaceModel> interfaceList { get; set; }
        public List<NamespaceModel> namespaceList { get; set; }

        public DocumentModel()
        {
            // initialise with default params

            this.Name = "";
            this.classList = new List<ClassModel>();
            this.arrowList = new List<ArrowModel>();
            this.interfaceList = new List<InterfaceModel>();
            this.namespaceList = new List<NamespaceModel>();
        }
    }
}