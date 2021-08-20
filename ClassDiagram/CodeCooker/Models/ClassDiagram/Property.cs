using CodeCooker.Models.ClassDiagram;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public class Property
    {

        public string Vis
        {
            get { return vis; }
            set
            {
                vis = value;
                Visibility = ConvertVisibilityFromString.ConvertStringToVis(value);
            }
        }
        private string vis;
        public Visibility Visibility = Visibility.PUBLIC;
        public string Type { get; set; }
        public string Name { get; set; }
        public bool Static { get; set; }

    }
}