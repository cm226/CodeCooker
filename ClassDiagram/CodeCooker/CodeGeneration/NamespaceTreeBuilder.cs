using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CodeCooker.Models.ClassDiagram;

namespace CodeCooker.CodeGeneration
{
    public class NamespaceTreeBuilder
    {
        List<CodeDom.OO.Dom.NamespaceGroup> namespaces = new List<CodeDom.OO.Dom.NamespaceGroup>();
        
        public CodeDom.OO.Dom.NamespaceGroup createOrGet(NamespaceModel ns)
        {
            foreach (CodeDom.OO.Dom.NamespaceGroup group in namespaces)
            {
                if (group.ID == ns.id)
                {
                    return group;
                }
            }

            CodeDom.OO.Dom.NamespaceGroup newNamespace = new CodeDom.OO.Dom.NamespaceGroup(ns.Name, ns.id);
            namespaces.Add(newNamespace);
            return newNamespace;
        }

        public List<CodeDom.OO.Dom.NamespaceGroup> UnFlatten()
        {
            List<CodeDom.OO.Dom.NamespaceGroup> rootNodes = new List<CodeDom.OO.Dom.NamespaceGroup>();
            foreach (CodeDom.OO.Dom.NamespaceGroup nsGroup in this.namespaces)
            {
                if (nsGroup.parent == null)
                    rootNodes.Add(nsGroup);
            }
            return rootNodes;
        }
    }
}