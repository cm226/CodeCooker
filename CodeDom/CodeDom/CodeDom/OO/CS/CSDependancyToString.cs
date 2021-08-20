using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{

    public class CSDependancyToString
    {
        public String DependancyToString(Dependancy dep)
        {
            if(dep.StandardDependancy != Dependancy.StandardDependancyValue.NOT_SET)
            {
                switch(dep.StandardDependancy)
                {
                    case Dependancy.StandardDependancyValue.LIST:
                        return "System.System.Collections.Generic";
                    default:
                        throw new NotImplementedException("a dependancy value was switched that was not handeled");
                }
            }
            else if (dep.ProjectTypeDependancy != null)
            {
                Interface dependancy = dep.ProjectTypeDependancy;
                if(dependancy.Namespaces.Count > 0)
                    return String.Join(".", dependancy.Namespaces);
            }

            return dep.Name;
        }
    }
}
