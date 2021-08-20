using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom
{
   
    public interface IConstList<T> : IEnumerable<T>
    {
        int Count {get;}
    }
}
