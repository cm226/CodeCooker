using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom.Completeres
{
    public class VoidDetector : CompleterDecorator
    {
         public VoidDetector()
        {

        }

         public VoidDetector(CompleterDecorator decorator)
            : base(decorator)
        {

        }

        public override void Complete(GenericClass gclass)
        {
            List<Method> allMethodsInClass = new List<Method>();
            allMethodsInClass.AddRange(gclass.PublicMethods);
            allMethodsInClass.AddRange(gclass.ProtectedMethods);
            allMethodsInClass.AddRange(gclass.PrivateMethods);

            foreach(Method m in allMethodsInClass)
            {
                if(m.Return.StringValue != null &&
                    m.Return.StringValue.ToUpper().CompareTo("VOID") == 0)
                {
                    m.Return = Types.VOID;
                }
            }

            base.Complete(gclass);
        }
    }
}
