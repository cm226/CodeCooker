using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public class ClassItem
    {
        public int classID { get; set; }
    }

    public class NamespaceModel
    {
        public int id { get; set; }
        public string Name { get; set; }
        public List<ClassItem> classes{ get; set; }
        public Point Position { get; set; }
        public Point Size { get; set; }

    }
}