// Conversion output is limited to 2048 chars
// Share Varycode on Facebook and tweet on Twitter
// to double the limits.

using CodeDom.OO.C__;
using CodeDom.OO.Dom;
using CodeDomUnitTests.OO.Exceptions;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using CodeDom.OO.Utils;

/*
 * CppClass.cpp
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */

namespace CodeDom.OO.CPP
{
    public partial class CppHeader
    {
        GenericClass gclass;
        CPPDependancyToString depToString;
        ICodeWritter headerFile;
        ItypeToString typeToStr = new CppTypeToString();

        public CppHeader(GenericClass toWrite)
        {
            this.gclass = toWrite;
            this.depToString = new CPPDependancyToString(this.gclass.Namespaces.Count);
        }
        public void Dispose()
        {
            // TODO Auto-generated destructor stub
        }
        public void write(string dir)
	    {
		    if (dir == null || this.gclass == null)
			    throw new ArgumentExeption("");

		    string headerFileName = string.Format("{0}\\{1}.h",dir,this.gclass.Name,".h");

            using (headerFile = new CodeWritter(headerFileName))
            {
                openHeader();
		        writeDependanceys(headerFile);
                openNamespaces();
                openClass();
                writeClassBody();
                closeClass();
                closeNamespaces();
                closeHeader();
            }
        }

        private void openHeader()
        {
            string tmpString = "";

            foreach (string ns in this.gclass.Namespaces)
                tmpString += (ns + "_").ToUpper();

            tmpString += this.gclass.Name.ToUpper();

            headerFile.WriteLine("#ifndef _{0}_", tmpString);
            headerFile.WriteLine("#define _{0}_", tmpString);
            headerFile.Indent();
        }
        private void closeHeader()
        {
            headerFile.Unindent();
            headerFile.WriteLine(" #endif");
        }
        private void openNamespaces()
        {
            foreach (string ns in this.gclass.Namespaces)
            {
                headerFile.WriteLine("namespace {0} {{", ns);
                headerFile.Indent();
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
        private void openClass()
        {
            if (!string.IsNullOrWhiteSpace(this.gclass.PreClassModStr))
                headerFile.Write("{0} ", this.gclass.PreClassModStr);
            
            if(!string.IsNullOrWhiteSpace(this.gclass.ClassComment))
            {
                headerFile.WriteLine("");
                BlockComment classHeaderComment = new BlockComment(this.headerFile, 40);
                classHeaderComment.comment = this.gclass.ClassComment;
                classHeaderComment.write();
            }
            
            headerFile.Write("class");

            if(!string.IsNullOrWhiteSpace(this.gclass.PostClassModStr))
                headerFile.WriteNoIndent(" {0}",this.gclass.PostClassModStr);

            headerFile.WriteNoIndent(" {0}", this.gclass.Name);
           
            GenericClass baseClass;
            bool baseClassValid = this.gclass.getBaseClass(out baseClass);

            if (baseClassValid)
            {
                if (baseClass.Name.CompareTo("") != 0)
                    headerFile.WriteNoIndent(" : public {0}", convertClassForHeader(baseClass));
                if (baseClass.GenericTypeSet)
                {
                    string genericType;
                    genericType = typeToStr.convertType(baseClass.GenericType, this.gclass);
                    headerFile.WriteNoIndent("<{0}>", genericType);
                }
            }
            IConstList<Interface> implementedInterfaces = this.gclass.InterfacesImplemented;
            if (implementedInterfaces.Count > 0)
            {
                if (!baseClassValid)
                    headerFile.WriteNoIndent(" :");
                else
                    headerFile.WriteNoIndent(",");
                int interfaceCounter = 0;
                foreach (Interface implementedInterface in implementedInterfaces)
                {
                    if (interfaceCounter != 0)
                        headerFile.WriteNoIndent(",");
                    headerFile.WriteNoIndent(" public ");
                    headerFile.WriteNoIndent(convertClassForHeader(implementedInterface));
                    interfaceCounter++;
                }
            }
            headerFile.WriteLineNoIndent("");
            headerFile.WriteLine("{ ");
            headerFile.Indent();
        }
        private void closeClass()
        {
            headerFile.Unindent();
            headerFile.WriteLine("}; ");
        }
        private void writeClassBody()
        {
            string[] accessMods = { "private:", "public:", "protected:" };
            headerFile.WriteLine("//ctor dtor");
            headerFile.WriteLine("public:");
            headerFile.Indent();
            if (!gclass.ConstructorSet)
                headerFile.WriteLine("{0}::{0}();", gclass.Name);
            else
            {
                headerFile.Write("{0}::{0}(", gclass.Name);
                this.writeArgs(headerFile, this.gclass.Constructor, typeToStr);
                headerFile.WriteNoIndent(");\r\n");
            }

            if (!gclass.DestructorSet)
                headerFile.WriteLine("virtual {0}::~{0}();", gclass.Name);
            else
            {
                headerFile.Write("virtual {0}::~{0}(", gclass.Name);
                this.writeArgs(headerFile, this.gclass.Destructor, typeToStr);
                headerFile.WriteNoIndent(");\r\n");
            }
            headerFile.Unindent();
            this.writeMembers(headerFile, accessMods, typeToStr);
            this.writeMethods(headerFile, accessMods, typeToStr);
        }

        private string convertClassForHeader(Interface converte)
        {
            string converted = "";
            if(converte.Namespaces.Count > 0)
            {
                converted = string.Join("::", converte.Namespaces)+"::";
            }
            converted += converte.Name;
            return converted;
        }
        private void writeDependanceys(ICodeWritter file)
        {
            string depStr = "";
            foreach(Dependancy dep in this.gclass.Dependancys)
            {
                depStr = depToString.ToString(dep);
                file.WriteLine("#include {0}", depStr);
	        }

        }
        private void writeMembers(ICodeWritter headerFile, string[] accessMods, ItypeToString typeToStr)
        {
	        List<Member>[] memberArr = new List<Member>[3]{this.gclass.PrivateProperties,
                                   this.gclass.PublicProperties,
                                   this.gclass.ProtectedProperties };

	        string tmpString, genericTypeStr;

            headerFile.WriteLine("");
	        headerFile.WriteLine("//Member Variables");
	        // member variables
	        for(int i =0; i < 3; i ++)
	        {
		        headerFile.WriteLine("{0}",accessMods[i]);
                headerFile.Indent();
		        foreach(Member member in memberArr[i])
		        {
                    tmpString = "";
                    if (member.IsStatic || this.gclass.IsStatic)
                        tmpString = "static ";

			        tmpString += typeToStr.convertType(member.Return, this.gclass);
			        headerFile.Write("{0} {1}", tmpString ,member.Name);
			        if(member.GenericsType != Types.UNSPECIFIED)
			        {
				        genericTypeStr = typeToStr.convertType(member.GenericsType, this.gclass);
				        headerFile.WriteLineNoIndent("<{0}>",genericTypeStr);
			        }

			        headerFile.WriteLineNoIndent(";");
		        }
                headerFile.Unindent();
	        }
        }
        private void writeMethods(ICodeWritter headerFile, string[] accessMods, ItypeToString typeToStr)
        {
	        List<Method>[] methodArr = new List<Method>[3]{this.gclass.PrivateMethods,
                                                           this.gclass.PublicMethods,
                                                           this.gclass.ProtectedMethods};
	        string tmpString = "";
	        string tmpStr2;

            headerFile.WriteLine("");
	        headerFile.WriteLine("//Methods");
		        Type returnT;
		        // methods
		        for(int i =0; i < 3; i ++)
		        {
			        headerFile.WriteLine(accessMods[i]);
                    headerFile.Indent();
			        foreach(Method method in methodArr[i])
                    {
                        BlockComment methodComment = new BlockComment(this.headerFile, 40);
                        methodComment.comment = method.Comment;
                        methodComment.write();

                        tmpString = "";
				        returnT =  method.Return;
                        if (method.Static || this.gclass.IsStatic)
                            tmpString = "static ";
                        else if(method.Abstract || method.IsOverriden)
                            tmpString = "virtual ";

				        tmpString += typeToStr.convertType(returnT, this.gclass);
				        tmpStr2=method.Name;

				        headerFile.Write("{0} {1}(",tmpString,tmpStr2);

				        this.writeArgs(headerFile,method,typeToStr);

                        if(method.Abstract && !method.Static)
                            headerFile.WriteLineNoIndent(") = 0;");
                        else
                            headerFile.WriteLineNoIndent(");");
				        }
                    headerFile.Unindent();
		        }
        }
        private void writeArgs(ICodeWritter headerFile, Method method, ItypeToString typeToStr)
        {
	        string tmpString;

	        //args
	      for(int i = 0; i < method.Arguments.Count; i++)
	        {
                Method.typeName arg = method.Arguments[i];
		        tmpString = typeToStr.convertType(arg.t, this.gclass);
		        headerFile.WriteNoIndent("{0} {1}",tmpString, arg.name);

                if (i != method.Arguments.Count - 1)
                    headerFile.WriteNoIndent(",");
	        }
        }
}
}
