using CodeDom.OO.Utils;
using CodeDomUnitTests.OO.Exceptions;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    public class CSClass : CSInterface
    {
        private GenericClass gclass;
        private DefaultTypeValue defaults = new DefaultTypeValue();

        public CSClass(GenericClass gclass):base(gclass)
        {
            this.gclass = gclass;
        }

        public override void write(ICodeWritter outputFile)
        {
            base.outFile = outputFile;
            
            base.writeDpendanceys();
            base.writeOpenNamespaces();
            writeOpenClass();
            writeConstructor();
            writeMembers();
            writeMethods();
            writeCloseClass();
            base.writeCloseNamespaces();
        }

        private void writeOpenClass()
        {
            if (!Utils.validName(this.gclass.Name))
                throw new InvalidNameException("The Class name: "+this.gclass.Name+" is invalid for CS");

            writeHeaderComment();
            string modifier = "";
            if (this.gclass.IsStatic)
                modifier = "static ";
            else if (this.gclass.IsAbstract)
                modifier = "abstract ";

            if (this.gclass.IsStatic && this.gclass.IsAbstract)
                throw new Exceptions.CodeDomException("A class cannot be abstract and static in C#");

            this.outFile.Write("{1} {2}class {0}", this.gclass.Name,
                                                VisibilityToString.convert(this.gclass.Visibiltity),
                                                modifier);
            GenericClass baseClass;
            if (this.gclass.getBaseClass(out baseClass))
            {
                this.outFile.WriteNoIndent(" : {0} ", baseClass.Name);
                if (gclass.InterfacesImplemented.Count > 0)
                    this.outFile.WriteNoIndent(",");
            }
            else if (gclass.InterfacesImplemented.Count > 0)
                this.outFile.WriteNoIndent(" : ");
            base.writeImplementedInterfaces();
            this.outFile.WriteLineNoIndent("");
            this.outFile.WriteLine("{");
            this.outFile.Indent();
        }

        private void writeConstructor()
        {
            if (this.gclass.ConstructorSet)
            {
                CSConstructor ctorWriter = new CSConstructor(this.outFile);
                ctorWriter.WriteConstructr(this.gclass.Constructor);
            }
        }

        private void writeMembers()
        {
            this.writeMemberGroup(this.gclass.PublicProperties, "public");
            this.writeMemberGroup(this.gclass.ProtectedProperties, "protected");
            this.writeMemberGroup(this.gclass.PrivateProperties, "private");
        }

        private void writeMemberGroup(List<Member> group, string groupName)
        {
            CSTypeToString typeToString = new CSTypeToString();
            foreach (Member member in group)
            {
                if (!Utils.validName(member.Name))
                    throw new InvalidNameException("The Class member: " + member.Name + " is invalid for CS");

                string modifier = " ";
                if (member.IsStatic)
                    modifier = " static ";

                this.outFile.WriteLine("{2}{3}{0} {1};",
                    typeToString.ConvertType(member.Return),
                    member.Name,
                    groupName,
                    modifier);
            }
        }

        private new void writeMethods()
        {
            CSMethod methodWriter = new CSMethod(this.outFile);
            methodWriter.WriteMethods(this.gclass.PublicMethods, "public");
            methodWriter.WriteMethods(this.gclass.ProtectedMethods, "protected");
            methodWriter.WriteMethods(this.gclass.PrivateMethods, "private");
        }

        private void writeCloseClass()
        {
            this.outFile.Unindent();
            this.outFile.WriteLine("}");
        }

    }
}
