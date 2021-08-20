using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.C__
{
    public class CPPDependancyToString
    {
        private int numNamespaces;
        private string dependancyPreFix = "";
        public CPPDependancyToString(int numNamespaces)
        {
            this.numNamespaces = numNamespaces;
            StringBuilder dependancyPreFixBuilder = new StringBuilder();
            for (int i = 0; i < numNamespaces; i++)
            {
                dependancyPreFixBuilder.Append("..\\");
            }
            this.dependancyPreFix = dependancyPreFixBuilder.ToString();

        }
        public string ToString(Dependancy dep)
        {
            if(dep.StandardDependancy != Dependancy.StandardDependancyValue.NOT_SET)
            {
                switch(dep.StandardDependancy)
                {
                    case Dependancy.StandardDependancyValue.LIST:
                        return "<vector>";
                    case Dependancy.StandardDependancyValue.STRING:
                        return "<string>";
                    case Dependancy.StandardDependancyValue.DATE_TIME:
                        return "<time.h>";
                }
            }
            else if(dep.ProjectTypeDependancy != null)
            {
                List<string> namespaces = dep.ProjectTypeDependancy.Namespaces.ToList();
                if (namespaces.Count > 0)
                    return string.Format("\"{2}{0}\\{1}.h\"", string.Join("\\", namespaces), dep.ProjectTypeDependancy.Name, this.dependancyPreFix);
                else
                    return string.Format("\"{1}{0}.h\"", dep.ProjectTypeDependancy.Name,this.dependancyPreFix); ;
            }
            return string.Format("\"{0}\"",dep.StandardLibName);
        }
    }
}
