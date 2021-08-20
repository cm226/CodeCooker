using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.DiagramGeneric
{
    public class DocumentModelForSave
    {
        public string Name { get; set; }

        [JsonIgnore]
        public CodeCooker.Models.ClassDiagram.Version VersionModel;
        private string version;
        public string Version
        {
            get { return this.version; }
            set
            {
                this.version = value;
                this.VersionModel = new ClassDiagram.Version(value);
            }
        }
    }
}