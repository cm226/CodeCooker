using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram.Arrows
{
    public class Endpoint
    {
        public bool Locked { get; set; }
        public int LockedClass { get; set; }
        public int LockedIndex { get; set; }
        public Point Position { get; set; }
    }
}