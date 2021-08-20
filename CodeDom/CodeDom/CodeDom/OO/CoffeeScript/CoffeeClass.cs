using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeDom.OO.Utils;

namespace CodeDom.OO.CoffeeScript
{
    public class CoffeeClass : CoffeeInterface
    {
        GenericClass gclass;

        public CoffeeClass(GenericClass gclass) : base(gclass) 
        {
            this.gclass = gclass;
        }

        public new void Write(ICodeWritter outFile)
        {
            this.outFile = outFile;
            openClass();
            MixinInterfaces();
            MixinBaseClass();
            createConstructor();
            writeMethods();
            closeClass();
        }

        private void createConstructor()
        {
            this.gclass.Constructor.Name = "constructor";
            base.writeMethod(this.gclass.Constructor);
            outFile.Indent();
            if(this.gclass.Constructor.BaseClassArgs.Count > 0)
                this.outFile.WriteLine("super({0})",buildArgumentString(this.gclass.Constructor.BaseClassArgs));
            writeAllMemebers();
            outFile.Unindent();
        }

        private new void openClass()
        {
            writeHeaderComment();
            outFile.Write("class {0}", buildClassName());
            if (this.gclass.InterfacesImplemented.Count > 0 || this.gclass.BaseClassSet)
                outFile.WriteNoIndent(" extends Module");

            outFile.WriteLine("");
            outFile.Indent();
        }

        private string buildClassName()
        {
            StringBuilder nameBuilder = new StringBuilder();
            if (this.gclass.Namespaces.Count > 0)
            {
                nameBuilder.Append(this.gclass.Namespaces[0]);
                for (int i = 1; i < this.gclass.Namespaces.Count; i++)
                    nameBuilder.AppendFormat(".{0}",this.gclass.Namespaces[i]);

                nameBuilder.AppendFormat(".{0}",this.gclass.Name);
            }
            else
                nameBuilder.Append(this.gclass.Name);

            return nameBuilder.ToString();
            
        }

        private void MixinBaseClass()
        {
            if (gclass.BaseClassSet)
            {
                GenericClass baseClass;
                gclass.getBaseClass(out baseClass);
                outFile.WriteLine("@include {0}",baseClass.Name);
            }
        }

        protected override void writeAllMemebers()
        {
            List<Member> allmembers = new List<Member>();
            allmembers.AddRange(this.gclass.PublicProperties);
            allmembers.AddRange(this.gclass.ProtectedProperties);

            foreach (Member member in allmembers)
            {
                outFile.WriteLine(@"@{0} = null", member.Name);
            }

            foreach(Member member in this.gclass.PrivateProperties)
            {
                outFile.WriteLine(@"{0} = null", member.Name);
            }
        }

        private void writeMethods()
        {
            List<Method> allMethods = new List<Method>();
            allMethods.AddRange(this.gclass.PublicMethods);
            allMethods.AddRange(this.gclass.ProtectedMethods);

            writePrivateMethods();
            foreach (Method method in allMethods)
            {
                    writeMethod(method);
            }
        }

        private void writePrivateMethods()
        {
            foreach(Method method in this.gclass.PrivateMethods)
            {
                writePrivateMethod(method);
            }
        }

        private void writePrivateMethod(Method method)
        {
            outFile.WriteLine("{0}= ({1})->", method.Name, buildArgumentString(method.Arguments));
        }

    }
}
