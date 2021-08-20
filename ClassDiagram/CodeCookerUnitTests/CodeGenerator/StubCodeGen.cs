using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeCookerUnitTests.CodeGenerator
{
    class StubCodeGen : CodeDom.OO.AbstractOOCodeGenerator
    {
        public List<CodeDom.OO.GenericClass> classes = new List<CodeDom.OO.GenericClass>();
        public List<CodeDom.OO.Interface> interfaces = new List<CodeDom.OO.Interface>();

        public StubCodeGen():base("C:\\")
        {

        }

        public override void addClass(CodeDom.OO.GenericClass gclass)
        {
            this.classes.Add(gclass);
        }

        public override void addInterface(CodeDom.OO.Interface interfaceModel)
        {
            this.interfaces.Add(interfaceModel);
        }

        public override void save()
        {
            
        }
    }
}
