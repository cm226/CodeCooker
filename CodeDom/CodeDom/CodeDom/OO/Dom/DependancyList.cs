using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom
{
    class DependancyComparer 
        : IComparer<Dependancy>
    {
        public int Compare(Dependancy x, Dependancy y)
        {
            // standard dependanceys should come first in the list
            if(x.StandardDependancy != Dependancy.StandardDependancyValue.NOT_SET)
            {
                if (y.StandardDependancy != Dependancy.StandardDependancyValue.NOT_SET)
                {
                    if (y.StandardDependancy == x.StandardDependancy)
                        return 0;

                    if (x.StandardDependancy < y.StandardDependancy)
                        return -1;
                }
                return 1;
            }
            // Then Project dependanceys (Interfaces and classes defined in the project)
            if(x.ProjectTypeDependancy != null)
            {
                if(y.ProjectTypeDependancy != null)
                {
                    if(x.ProjectTypeDependancy == y.ProjectTypeDependancy)
                    {
                        return 0;
                    }
                    return 1;
                }
                return 1;
            }

            
            if (x.StandardLibName.CompareTo(y.StandardLibName) == 0)
                return 0;

            // other shit
            return -1;
        }
    }
    public class DependancyList
        : SortedSet<Dependancy>
    {
        public DependancyList()
            :base(new DependancyComparer())
        {

        }

        public void RemoveProjectDependancy(Interface interfce)
        {
            for( int i = 0; i < this.Count; i++)
            {
                Dependancy dep  = this.ElementAt(i);
                if(dep.ProjectTypeDependancy != null &&
                    dep.ProjectTypeDependancy == interfce)
                {
                    this.Remove(dep);
                    return;
                }
            }
        }
    }
}
