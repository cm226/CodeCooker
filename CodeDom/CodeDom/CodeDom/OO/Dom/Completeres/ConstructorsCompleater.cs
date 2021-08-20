using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom.Completeres
{
    public class ConstructorCompleater : CompleterDecorator
    {
        public ConstructorCompleater()
        {

        }

        public ConstructorCompleater(CompleterDecorator decorator)
            : base(decorator)
        {

        }

        public override void Complete(GenericClass gclass)
        {
            if (gclass.ConstructorSet)
            {
                if (gclass.BaseClassSet)
                {
                    if (gclass.BaseClass.Constructor != null)
                    {
                        ArgumentPairing argumentPairing = new ArgumentPairing();
                        argumentPairing.pairUpArguments(gclass.Constructor, gclass.BaseClass.Constructor);
                    }
                }
                
            }
            else
            {
                // a base class exsists but there is no constructor set
                if(gclass.BaseClassSet)
                {
                    GenericClass baseClass;
                    gclass.getBaseClass(out baseClass);
                    if(baseClass.ConstructorSet)
                    {
                        Method generatedConstuctor = new Method(gclass.Name);
                        foreach (Method.typeName arg in baseClass.Constructor.Arguments)
                        {
                            generatedConstuctor.addArgs(arg.t, arg.name);
                        }

                        // reffrence should be ok for this since at this point we have closed the class
                        generatedConstuctor.BaseClassArgs = baseClass.Constructor.Arguments;
                        gclass.Constructor = generatedConstuctor;
                    }
                }
            }

            base.Complete(gclass);
        }

       
    }
}
