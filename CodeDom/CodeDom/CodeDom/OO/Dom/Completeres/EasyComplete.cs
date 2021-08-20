using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom.Completeres
{
    public class EasyComplete
    {
        public CompleterDecorator baseCompleter;

        public EasyComplete()
        {
            baseCompleter = new OverrideCompleter(
                                    new ConstructorCompleater(
                                    new VoidDetector()));
            
        }

        public void Complete(GenericClass gClass)
        {
            this.baseCompleter.Complete(gClass);
        }
    }
}
