using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom.Completeres
{
    public class OverrideCompleter : CompleterDecorator
    {
         public OverrideCompleter()
        {

        }

         public OverrideCompleter(CompleterDecorator decorator)
            : base(decorator)
        {

        }

        public override void Complete(GenericClass gclass)
        {
            if(gclass.BaseClassSet)
            {
                GenericClass baseClass;
                gclass.getBaseClass(out baseClass);
                matchOverrides(gclass.PublicMethods, baseClass.PublicMethods);
                matchOverrides(gclass.PrivateMethods, baseClass.PrivateMethods);
                matchOverrides(gclass.ProtectedMethods, baseClass.ProtectedMethods);

            }
            base.Complete(gclass);
        }

        private void matchOverrides(List<Method> subClassMethods,
                                    List<Method> baseClassMethods)
        {
            foreach(Method subMethod in subClassMethods)
            {
                foreach(Method baseClassMethod in baseClassMethods)
                {
                    if(subMethod.Name.CompareTo(baseClassMethod.Name) ==0)
                    {
                        subMethod.Overriding = baseClassMethod;
                        baseClassMethod.IsOverriden = true;
                        ArgumentPairing argPairing = new ArgumentPairing();
                        argPairing.pairUpArguments(subMethod, baseClassMethod);
                    }
                }
            }

        }
    }
}
