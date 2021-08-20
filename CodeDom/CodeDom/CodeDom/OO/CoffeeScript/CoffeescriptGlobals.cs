using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeDom.OO.Utils;

namespace CodeDom.OO.CoffeeScript
{
    class CoffeescriptGlobals
    {
        List<Interface> allclassesAndInterfaces;
        public CoffeescriptGlobals(List<Interface> allClassesAndInterfaces)
        {
            this.allclassesAndInterfaces = allClassesAndInterfaces;
        }

        public void Write(ICodeWritter outFile)
        {
            // define all the namesoaces in the global file
            HashSet<string> alNamespaces = new HashSet<string>();
            foreach (Interface interfce in this.allclassesAndInterfaces)
            {
                foreach (string ns in interfce.Namespaces)
                    alNamespaces.Add(ns);
            }

            outFile.WriteLine("window.App =  # replace window with global or exports depending on your enviroment");
            outFile.Indent();
            foreach (string ns in alNamespaces)
                outFile.WriteLine("{0}: {{}}", ns);
        }
    }
}
