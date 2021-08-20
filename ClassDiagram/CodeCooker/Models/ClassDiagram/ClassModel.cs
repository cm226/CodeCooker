using CodeCooker.Models.ClassDiagram;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public class ClassModel
    {
        public int id { get; set; }
        public string Name { get; set; }
        public string vis 
        { 
            set
            {
                this.Visibility = ConvertVisibilityFromString.ConvertStringToVis(value);
                this.VisibilityStr = value;
            }
            get { return this.VisibilityStr; }
        }
        [JsonIgnore]
        public string VisibilityStr;
        [JsonIgnore]
        public Visibility Visibility = Visibility.PUBLIC;
        public bool Static { get; set; }
        public bool Abstract { get; set; }
        public CodeCooker.Models.ClassDiagram.Properties Properties { get; set; }
        public CodeCooker.Models.ClassDiagram.Methods Methods { get; set; }
        public Point Position { get; set; }
        public string Comment { get; set; }

        public ClassModel()
        {

            this.Properties = new CodeCooker.Models.ClassDiagram.Properties();
            this.Methods = new CodeCooker.Models.ClassDiagram.Methods();
        }
    }
}