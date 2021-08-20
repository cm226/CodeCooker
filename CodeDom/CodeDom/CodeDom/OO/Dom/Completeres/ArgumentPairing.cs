using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom.Completeres
{
    class ArgumentPairing
    {
        public void pairUpArguments(Method con, Method baseClassCon)
        {
            List<Method.typeName> constructorArgs = con.Arguments;
            List<Method.typeName> baseClassArgs = baseClassCon.Arguments;
            List<Object> matchedArgs = new List<object>();

            bool pairedArg = false;
            foreach (Method.typeName arg in baseClassArgs)
            {
                foreach (Method.typeName ctorArg in constructorArgs)
                {
                    if (arg.t.Equals(ctorArg.t) && !matchedArgs.Contains(arg))
                    {
                        pairedArg = true;
                        con.BaseClassArgs.Add(ctorArg);
                        matchedArgs.Add(arg);
                    }
                }

                if (!pairedArg)
                {
                    Method.typeName injectedCtorArg = new Method.typeName() { t = arg.t, name = arg.name };
                    con.Arguments.Add(injectedCtorArg);
                    con.BaseClassArgs.Add(injectedCtorArg);
                }
            }
        }
    }
}
