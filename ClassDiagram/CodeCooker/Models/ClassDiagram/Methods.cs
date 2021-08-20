using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public class Methods
    {
        public List<Method> Items { get; set; }

        public Methods()
        {
            this.Items = new List<Method>();
        }
    }
}