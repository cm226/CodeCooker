using CodeDom.OO.Utils;
using CodeDomUnitTests.OO.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    class CSMethod
    {
        protected ICodeWritter outFile;
        private DefaultTypeValue defaults = new DefaultTypeValue();

        public CSMethod(ICodeWritter writer)
        {
            this.outFile = writer;
        }

        public void WriteMethodsSpec(List<Method> methods)
        {
            CSTypeToString typeToString = new CSTypeToString();

            foreach (Method method in methods)
            {
                if (!Utils.validName(method.Name))
                    throw new InvalidNameException("The Class method: " + method.Name + " is invalid for CS");


                this.outFile.Write("{0} {1}(",
                    typeToString.ConvertType(method.Return),
                    method.Name);
                this.writeArguments(method.Arguments);
                this.outFile.WriteLineNoIndent(");");
            }
        }

        public virtual void WriteMethods(List<Method> methods, string groupName)
        {
            CSTypeToString typeToString = new CSTypeToString();

            foreach (Method method in methods)
            {
                if (!Utils.validName(method.Name))
                    throw new InvalidNameException("The Class method: " + method.Name + " is invalid for CS");

                BlockComment methodComment = new BlockComment(this.outFile, 40);
                methodComment.comment = method.Comment;
                methodComment.write();

                this.outFile.Write("{0} ",groupName);
                if (method.Static)
                    this.outFile.WriteNoIndent("static ");
                else if (method.Abstract) // C# methods cannot be abstract and static
                    this.outFile.WriteNoIndent("abstract ");

                if (method.IsOverriden && !method.Abstract) // C# abstract methods canot be virtual
                    this.outFile.WriteNoIndent("virtual ");

                if (method.Overriding != null)
                    this.outFile.WriteNoIndent("override ");
                
                this.outFile.WriteNoIndent("{0} {1}(",
                    typeToString.ConvertType(method.Return),
                    method.Name);
                this.writeArguments(method.Arguments);
                this.outFile.WriteNoIndent(")");
                if (method.Abstract)
                {
                    this.outFile.WriteLineNoIndent(";");
                }
                else
                {
                    this.outFile.WriteLineNoIndent("");
                    this.outFile.WriteLine("{");
                    this.outFile.Indent();
                    if (String.IsNullOrWhiteSpace(method.Content))
                    {
                        if(method.Overriding != null)
                        {
                            Method baseMethod = method.Overriding;
                            this.outFile.WriteLine("base.{0}({1});", baseMethod.Name,
                                                                    argListToString(method.BaseClassArgs));
                        }
                        if(method.Return != Types.VOID)
                            this.outFile.WriteLine("return " + this.defaults.defaultValue(method.Return) + ";");
                    }
                    else
                        this.outFile.WriteLine("");
                    this.outFile.Unindent();
                    this.outFile.WriteLine("}");
                }

            }
        }

        protected string argListToString(List<Method.typeName> args)
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

        protected void writeArguments(List<Method.typeName> args)
        {
            CSTypeToString typeToString = new CSTypeToString();
            string[] argArr = new string[args.Count];

            for (int i = 0; i < args.Count; i++ )
                argArr[i] = String.Format("{0} {1}", typeToString.ConvertType(args[i].t), args[i].name);
            
            this.outFile.WriteNoIndent(String.Join(",", argArr));
        }
        
    }
}
