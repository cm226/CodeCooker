using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom.Completeres
{
    public abstract class CompleterDecorator
    {
        private CompleterDecorator nextCloser = null;

        public CompleterDecorator()
        {

        }

        public CompleterDecorator(CompleterDecorator next)
        {
            nextCloser = next;
        }


        public virtual void Complete(GenericClass gclass)
        {
            if(this.nextCloser != null)
                this.nextCloser.Complete(gclass);
        }


    }
}
