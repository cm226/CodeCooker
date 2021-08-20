using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public class InterfaceModel
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
        public string VisibilityStr;
        public Visibility Visibility = Visibility.PUBLIC;
        public bool Static { get; set; }
        public List<Method> Methods { get; set; }
        public Point Position { get; set; }
        public string Comment { get; set; }
    }
}