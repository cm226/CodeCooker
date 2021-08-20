using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom
{
    public class InterfaceList 
        :   List<Interface>,
            IConstList<Interface>
    {
        public IEnumerator<Interface> GetEnumerator()
        {
            return base.GetEnumerator();
        }

        public int Count
        {
            get
            {
                return base.Count;
            }
        }
    }
}
