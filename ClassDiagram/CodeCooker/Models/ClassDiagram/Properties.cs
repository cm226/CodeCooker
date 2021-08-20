using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public class Properties
    {

        public List<Property> Items { get; set; }

        public Properties()
        {
            this.Items = new List<Property>();
        }
    }
}