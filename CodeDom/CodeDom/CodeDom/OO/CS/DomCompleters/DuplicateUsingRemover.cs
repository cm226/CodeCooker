using CodeDom.OO.Dom.Completeres;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS.DomCompleters
{
    public class DuplicateUsingRemover : CompleterDecorator 
    {
        GenericClass gClass;
        public DuplicateUsingRemover()
            : base()
        {

        }
        public DuplicateUsingRemover(CompleterDecorator wrapper)
            :base(wrapper)
        {

        }

        public override void Complete(GenericClass gclass)
        {
            this.gClass = gclass;
            Dictionary<int, List<Interface>> correlateingNamespaceCountDependanceys 
                = new Dictionary<int, List<Interface>>();

            foreach(Dependancy dependacy in gclass.Dependancys)
            {
                if(dependacy.ProjectTypeDependancy != null)
                {
                    if(!correlateingNamespaceCountDependanceys.ContainsKey(
                        dependacy.ProjectTypeDependancy.Namespaces.Count))
                    {
                        correlateingNamespaceCountDependanceys[
                        dependacy.ProjectTypeDependancy.Namespaces.Count] = new List<Interface>();
                    }
                    correlateingNamespaceCountDependanceys
                        [dependacy.ProjectTypeDependancy.Namespaces.Count].Add(
                        dependacy.ProjectTypeDependancy);
                }
            }

            foreach(List<Interface> correlateingNScount in correlateingNamespaceCountDependanceys.Values)
            {
                if(correlateingNScount.Count > 1)
                    removeDuplicateEntrys(correlateingNScount);
            }

            base.Complete(gclass);
        }

        private void removeDuplicateEntrys(List<Interface> correlatingNS)
        {
            int correlatringCount = correlatingNS.Count-1;
            int correlatingCountInner = 0;
            bool inconsistant = false;

            for(; correlatringCount >= 0; correlatringCount--)
            {
                for(correlatingCountInner = correlatringCount-1;
                    correlatingCountInner>=0; correlatingCountInner--)
                {
                    
                    for(int i = 0; i < correlatingNS[correlatringCount].Namespaces.Count; i++)
                    {
                        if(correlatingNS[correlatringCount].Namespaces[i].CompareTo(
                            correlatingNS[correlatingCountInner].Namespaces[i]) != 0)
                        {
                            inconsistant = true;
                            break;
                        }
                    }
                    if(!inconsistant) // namespaces match so remove the suplicate dependancy from the list
                    {
                        this.gClass.Dependancys.RemoveProjectDependancy(correlatingNS[correlatringCount]);
                        correlatingNS.RemoveAt(correlatringCount);
                        correlatringCount--;
                    }
                    inconsistant = false;
                }
            }
        }


    }
}
