using CodeCooker.Models.ClassDiagram;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public class Method
    {
        public Method()
        {
            this.Static = false;
            this.Abstract = false;
        }
        public string Vis
        {
            get{return vis;}
            set
            {
                vis = value;
                Visibility = ConvertVisibilityFromString.ConvertStringToVis(value);
            }
        }
        private string vis;
        public Visibility Visibility;
        public string Return { get; set; }
        public string Name { get; set; }
        public string Args { get; set; }
        public string Comment { get; set; }
        public string Flags { 
            set
            {
                char[] flags = value.ToArray<char>();
                if (flags[0] == '1')
                    this.Static = true;
                if (flags[1] == '1')
                    this.Abstract = true;

            }
        }

        public bool Static { get; set; }
        public bool Abstract { get; set; }
    }
}