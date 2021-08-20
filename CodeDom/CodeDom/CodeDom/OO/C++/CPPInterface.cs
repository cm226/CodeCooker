using CodeDom.OO.Dom;
using CodeDom.OO.Utils;
using CodeDomUnitTests.OO.Exceptions;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.C__
{
    public class CPPInterface
    {
        CPPDependancyToString depToString;
        protected Interface gclass;

        private ICodeWritter headerFile;
        private string rootDirectory = "";
        private ItypeToString typeToStr = new CppTypeToString();

        public CPPInterface(Interface toWrite)
        {
            this.gclass = toWrite;
            this.depToString  = new CPPDependancyToString(this.gclass.Namespaces.Count);
        }
        public void Dispose()
        {
            // TODO Auto-generated destructor stub
        }
        public void write(string dir)
        {
            if (dir == null || this.gclass == null)
                throw new ArgumentExeption("");

            rootDirectory = dir;
            
            StringBuilder tempFileStream = new StringBuilder();
            string headerFileName = buildHeaderDirectory();
            Directory.CreateDirectory(headerFileName);
            headerFileName += "\\" + this.gclass.Name;
            headerFileName += ".h";

            using (headerFile = new CodeWritter(headerFileName))
            {
                writeFileHeader();
                writeDependanceys(headerFile);
                writeNamespaces();
                writeOpenClass();
                writeMethods();
                writeCloseClass();
                closeNamespaces();
                writeFileFooter();
            }
        }

        private void writeCloseClass()
        {
            headerFile.Unindent();
            headerFile.WriteLine("};");
        }

        private void writeOpenClass()
        {
            if(!string.IsNullOrWhiteSpace(this.gclass.PreClassModStr))
                headerFile.Write("{0} ", this.gclass.PreClassModStr);

            headerFile.Write("class");
            headerFile.WriteNoIndent("{0} ", this.gclass.PostClassModStr);
            headerFile.WriteNoIndent(this.gclass.Name);

            IConstList<Interface> interfaces = this.gclass.InterfacesImplemented;

            if (interfaces.Count > 0)
            {
                headerFile.WriteNoIndent(" : public ");
                Interface lastInterface = interfaces.Last();
                foreach (Interface interfaceModel in interfaces)
                {
                    headerFile.WriteNoIndent(convertClassForHeader(interfaceModel));
                    if (interfaceModel.GenericTypeSet)
                    {
                        string genericType;
                        genericType = typeToStr.convertType(interfaceModel.GenericType, this.gclass);
                        headerFile.WriteNoIndent("<{0}>", genericType);
                    }
                    if (lastInterface != interfaceModel)
                        headerFile.WriteNoIndent(", ");
                }
            }

            headerFile.WriteLineNoIndent("{ ");
            headerFile.Indent();
        }

        private void writeFileFooter()
        {
            headerFile.WriteLine(" #endif");
        }

        private void writeFileHeader()
        {
            string tmpString = "";

            foreach (string ns in this.gclass.Namespaces)
                tmpString += (ns + "_").ToUpper();

            tmpString += this.gclass.Name.ToUpper();

            headerFile.WriteLine("#ifndef _{0}_", tmpString);
            headerFile.WriteLine("#define _{0}_", tmpString);
        }

        private void writeNamespaces()
        {
            if (this.gclass.Namespaces.Count > 0)
            {
                foreach (string ns in this.gclass.Namespaces)
                {
                    this.headerFile.WriteLine("namespace {0} {{", ns);
                    this.headerFile.Indent();
                }
            }
        }

        private void closeNamespaces()
        {
            foreach (string ns in this.gclass.Namespaces)
            {
                headerFile.Unindent();
                headerFile.WriteLine("}");
            }
        }

        private string buildHeaderDirectory()
        {
            StringBuilder headerFileName = new StringBuilder(this.rootDirectory);
            
            foreach (string ns in this.gclass.Namespaces)
                headerFileName.AppendFormat("\\{0}",ns);

            return headerFileName.ToString();
        }

        private void writeDependanceys(ICodeWritter file)
        {
            string depStr = "";
            foreach (Dependancy dep in this.gclass.Dependancys)
            {
                depStr = depToString.ToString(dep);
                file.WriteLine("#include {0}", depStr);
            }

        }

        private string convertClassForHeader(Interface converte)
        {
            string converted = "";
            if (converte.Namespaces.Count > 0)
            {
                converted = string.Join("::", converte.Namespaces) + "::";
            }
            converted += converte.Name;
            return converted;
        }

        
        void writeMethods()
        {
            string[] accessMods = { "private:", "public:", "protected:" };
            List<Method>[] methodArr = new List<Method>[1]{gclass.PublicMethods};
            string tmpString;
            string tmpStr2;

            Type returnT;
            // methods
            for (int i = 0; i < 1; i++)
            {
                headerFile.WriteLine("public:");
                headerFile.Indent();
                foreach (Method method in methodArr[i])
                {
                    returnT = method.Return;
                    tmpString = typeToStr.convertType(returnT, this.gclass);
                    tmpStr2 = method.Name;

                    headerFile.Write("virtual {0} {1}(", tmpString, tmpStr2);

                    this.writeArgs(headerFile, method, typeToStr);

                    headerFile.WriteLineNoIndent(") = 0;");
                }
                headerFile.Unindent();
            }
        }

        private void writeArgs(ICodeWritter headerFile, Method method, ItypeToString typeToStr)
        {
            string tmpString;

            //args
            for (int i = 0; i < method.Arguments.Count; i++)
            {
                Method.typeName arg = method.Arguments[i];
                tmpString = typeToStr.convertType(arg.t, this.gclass);
                headerFile.WriteNoIndent("{0} {1}", tmpString, arg.name);

                if (i != method.Arguments.Count - 1)
                    headerFile.WriteNoIndent(",");
            }
        }
    }
}
