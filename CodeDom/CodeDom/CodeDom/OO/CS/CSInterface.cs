using CodeDom.OO.Utils;
using CodeDomUnitTests.OO.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    public class CSInterface : IWriteable
    {
        private Interface interfaceModel;
        protected ICodeWritter outFile;

        public CSInterface(Interface model)
        {
            this.interfaceModel = model;
        }

        public virtual void write(ICodeWritter outputFile)
        {
            this.outFile = outputFile;
            writeDpendanceys();
            writeOpenNamespaces();
            writeOpenInterface();
            writeMethods();
            writeCloseInterface();
            writeCloseNamespaces();
        }

        protected void writeDpendanceys()
        {
            // write standard Dependanceys
            this.outFile.WriteLine("using System;");
            this.outFile.WriteLine("using System.Collections.Generic;");
            this.outFile.WriteLine("using System.Linq;");
            this.outFile.WriteLine("using System.Text;");
            this.outFile.WriteLine("using System.Threading.Tasks;");
            
            CSDependancyToString depToString = new CSDependancyToString();
            string dependancyName = "";
            foreach (Dependancy dependacy in this.interfaceModel.Dependancys)
            {
                dependancyName = depToString.DependancyToString(dependacy);
                if(!string.IsNullOrWhiteSpace(dependancyName))
                    this.outFile.WriteLine("using {0};", dependancyName);
            }
        }

        protected void writeOpenNamespaces()
        {
            if (this.interfaceModel.Namespaces.Count > 0)
            {
                string namspaces = String.Join(".", this.interfaceModel.Namespaces.ToArray());
                this.outFile.Write("namespace {0}\n{{", namspaces);
                this.outFile.Indent();
            }
        }

        protected void writeOpenInterface()
        {
            if (!Utils.validName(this.interfaceModel.Name))
                throw new InvalidNameException("The Class name: " + this.interfaceModel.Name + " is invalid for CS");

            writeHeaderComment();
            this.outFile.Write("{1} interface {0}", this.interfaceModel.Name, 
                                                    VisibilityToString.convert(this.interfaceModel.Visibiltity));
            if (this.interfaceModel.InterfacesImplemented.Count > 0)
            {
                this.outFile.WriteNoIndent(" : ");
                this.writeImplementedInterfaces();
            }
            this.outFile.WriteLine("");
            this.outFile.WriteLine("{");
            this.outFile.Indent();
        }

        protected void writeHeaderComment()
        {
            if (!string.IsNullOrWhiteSpace(this.interfaceModel.ClassComment))
            {
                BlockComment classComment = new BlockComment(this.outFile, 40);
                classComment.comment = this.interfaceModel.ClassComment;
                classComment.write();
            }
        }

        protected void writeImplementedInterfaces()
        {
            if (this.interfaceModel.InterfacesImplemented.Count > 0)
            {
                CSTypeToString typeToString = new CSTypeToString();
                Interface lastImplementedInterface = this.interfaceModel.InterfacesImplemented.Last();
                foreach (Interface implementedInterface in this.interfaceModel.InterfacesImplemented)
                {
                    this.outFile.WriteNoIndent(implementedInterface.Name);
                    if (implementedInterface.GenericTypeSet)
                    {
                        this.outFile.WriteNoIndent(" <{0}>", typeToString.ConvertType(implementedInterface.GenericType));
                    }
                    if (implementedInterface != lastImplementedInterface)
                        this.outFile.WriteNoIndent(", ");
                }
            }
        }

        protected void writeMethods()
        {
            CSMethod methodWriter = new CSMethod(this.outFile);
            methodWriter.WriteMethodsSpec(this.interfaceModel.PublicMethods);
        }

        protected void writeCloseInterface()
        {
            this.outFile.Unindent();
            this.outFile.WriteLine("}");
        }

        protected void writeCloseNamespaces()
        {
            if (this.interfaceModel.Namespaces.Count > 0)
            {
                this.outFile.Unindent();
                this.outFile.WriteLine("}");
            }
        }


    }
}
