// Conversion output is limited to 2048 chars
// Share Varycode on Facebook and tweet on Twitter
// to double the limits.

using CodeDom.OO.C__;
using CodeDom.OO.Utils;
using CodeDomUnitTests.OO.Exceptions;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

/*
 * CppClass.cpp
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */

namespace CodeDom.OO.CPP
{
    public class CppClass
    {
        private GenericClass gclass;
        private ICodeWritter classFile;

        public CppClass(GenericClass toWrite)
        {
            this.gclass = toWrite;
        }
        public void Dispose()
        {

        }

        public void write(string dir)
        {

            if (dir == null || this.gclass == null)
                throw new ArgumentExeption("");

            if (!CodeDom.OO.C__.Utils.validCPPname(this.gclass.Name))
                throw new InvalidNameException("the Class name :" + this.gclass.Name + " is invalid for C++");

            string fileName = string.Format("{0}\\{1}.cpp",dir,this.gclass.Name);
            using (classFile = new CodeWritter(fileName))
            {
                classFile.WriteLine("#include \"{0}.h\" \n",this.gclass.Name);
                writeOpenNamespaces();
                writeConstructor();
                writeDestructor();
                writeMethods();
                writeCloseNamespaces();
            }
        }

        private void writeMethods()
        {
            foreach (Method privateMethod in this.gclass.PrivateMethods)
                this.writeMethod(privateMethod, classFile);
            foreach (Method protectedMethod in this.gclass.ProtectedMethods)
                this.writeMethod(protectedMethod, classFile);
            foreach (Method publicMethod in this.gclass.PublicMethods)
                this.writeMethod(publicMethod, classFile);
        }

        private void writeConstructor()
        {
            if (!this.gclass.ConstructorSet)
            {
                Method ctor = new Method(gclass.Name);
                ctor.Return = new Type("");
                this.writeMethod(ctor, classFile);
            }
            else
            {
                Method ctor = gclass.Constructor;
                ctor.Name = gclass.Name;
                ctor.Return = new Type("");
                this.writeMethod(ctor, classFile);
            }
        }

        private void writeDestructor()
        {
            if (!this.gclass.DestructorSet)
            {
                Method dtor = new Method("~" + gclass.Name);
                dtor.Return = new Type("");
                this.writeMethod(dtor, classFile);
            }
            else
            {
                Method dtor = new Method("~" + gclass.Name);
                dtor.Return = new Type("");
                dtor.Arguments = gclass.Destructor.Arguments;
                this.writeMethod(dtor, classFile);
            }
        }

        private void writeOpenNamespaces()
        {
            if (this.gclass.Namespaces.Count > 0)
            {
                foreach (string ns in this.gclass.Namespaces)
                {
                    this.classFile.WriteLine("namespace {0} {{", ns);
                    this.classFile.Indent();
                }
            }
        }

        private void writeCloseNamespaces()
        {
            if (this.gclass.Namespaces.Count > 0)
            {
                foreach (string ns in this.gclass.Namespaces)
                {
                    this.classFile.Unindent();
                    this.classFile.WriteLine("}");
                }
            }
        }
        private void writeMethod(Method meth, ICodeWritter fs)
	    {
            if (meth.Abstract)
                return;
			Type t = meth.Return;
		    string tempArgVal;

		    List<Method.typeName> args = meth.Arguments;
		    CppTypeToString typeToString = new CppTypeToString();

		    string returnStr = typeToString.convertType(t, this.gclass);
		    string methodName = meth.Name;
            if (!CodeDom.OO.C__.Utils.validCPPname(methodName))
                throw new InvalidNameException("The method name: "+methodName+" is invalid for C++");

            BlockComment methodComment = new BlockComment(this.classFile, 40);
            methodComment.comment = meth.Comment;
            methodComment.write();

            if(returnStr != "")
		        fs.Write("{0} {1}::{2}(",returnStr,this.gclass.Name,methodName);
            else
                fs.Write("{0}::{1}(", this.gclass.Name, methodName);
		    for(int i=0 ; i< args.Count; i++)
		    {
                Method.typeName type = args[i];
			    tempArgVal = typeToString.convertType(type.t, this.gclass);
			    fs.WriteNoIndent("{0} {1}",tempArgVal,type.name);

			    if(i != args.Count-1)
				    fs.WriteNoIndent(",");
		    }
		    
            string methodContent = meth.Content;
		    fs.WriteLineNoIndent(")");
		    Method ctor = this.gclass.Constructor;
		    if(meth == ctor)
		    {
			    
			    string memberGeneric;
                GenericClass baseClass = this.gclass.BaseClass;
                if (baseClass != null)
                {
                    fs.Write(":{0}", baseClass.Name);
                    if (baseClass.GenericTypeSet)
                    {
                        Type generType = baseClass.GenericType;
                        memberGeneric = typeToString.convertType(generType, this.gclass);
                        fs.WriteNoIndent("<{0}>", memberGeneric);
                    }

                    fs.WriteNoIndent("(");
                    if (baseClass.ConstructorSet)
                    {
                        Method baseCtor = baseClass.Constructor;
                        fs.WriteNoIndent(argListToString(baseCtor.Arguments));
                    }
                    fs.WriteLineNoIndent(")");
                }
		    }
		    fs.WriteLine("{");
            fs.Indent();
            if(meth.Overriding != null)
            {
                GenericClass baseClass;
                gclass.getBaseClass(out baseClass);
                fs.Write("{0}::{1}({2});",baseClass.Name,
                                          meth.Overriding.Name,
                                          argListToString(meth.BaseClassArgs));
            }
		    fs.WriteLine("{0}",methodContent);
            fs.Unindent();
		    fs.WriteLine("}");
        }

        private string argListToString(List<Method.typeName> args)
        {
            StringBuilder list = new StringBuilder();
            if (args.Count > 1)
            {
                list.Append(args[0].name);
                for (int i = 1; i < args.Count; i++)
                    list.Append(", ").Append(args[i].name);
            }
            return list.ToString();
        }

}
}