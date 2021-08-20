using CodeCooker.Models.ClassDiagram.Arrows;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public class ArrowModel
    {
        public string id { get; set; }
        public Endpoint Head { get; set; }
        public Endpoint Tail { get; set; }

        public ArrowModel()
        {
            this.Head = new Endpoint();
            this.Tail = new Endpoint();
        }
    }
}