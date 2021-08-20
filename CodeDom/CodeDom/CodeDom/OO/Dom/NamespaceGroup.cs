using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom
{
    public class NamespaceGroup
    {
        public NamespaceGroup parent {get;set;}
        private string name;
        
        public int ID { get; private set; }
        public List<Interface> InterfacesAndClassMembers{ get; private set; }
        public List<NamespaceGroup> Children { get; private set; }


        public NamespaceGroup(string name, int id)
        {
            this.InterfacesAndClassMembers = new List<Interface>();
            this.Children = new List<NamespaceGroup>();
            this.parent = null;
            this.name = name;
            this.ID = id;
        }

        public NamespaceGroup(NamespaceGroup parent, string name, int id)
        {
            this.InterfacesAndClassMembers = new List<Interface>();
            this.Children = new List<NamespaceGroup>();
            this.parent = parent;
            this.name = name;
            this.ID = id;
        }


        public void ApplyNS(string ns)
        {
            foreach(Interface classOrInterface in this.InterfacesAndClassMembers)
                classOrInterface.Namespaces.Add(ns);

            foreach (NamespaceGroup nsg in this.Children)
                nsg.ApplyNS(ns);
        }

        public void Apply()
        {
            ApplyNS(this.name);

            foreach (NamespaceGroup nsg in this.Children)
                nsg.Apply();
        }



    }
}
