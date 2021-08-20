using CodeDom.OO.Dom.Completeres;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS.DomCompleters
{
    public class AbstractMethodDetector : CompleterDecorator 
    {
        public AbstractMethodDetector(CompleterDecorator decorator)
            :base(decorator)
        {

        }

        public override void Complete(GenericClass gclass)
        {
            List<Method> visableMethods = new List<Method>();
            visableMethods.AddRange(gclass.PublicMethods);
            visableMethods.AddRange(gclass.ProtectedMethods);

            foreach (Method method in visableMethods)
            {
                if (method.Abstract)
                {
                    gclass.IsAbstract = true;
                    break;
                }
            }
            base.Complete(gclass);
        }
    }
}
