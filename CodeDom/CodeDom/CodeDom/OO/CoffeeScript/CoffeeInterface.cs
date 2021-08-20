using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeDom.OO.Utils;

namespace CodeDom.OO.CoffeeScript
{
    public class CoffeeInterface
    {
        Interface gInterface;
        protected ICodeWritter outFile;

        public CoffeeInterface(Interface gInterface)
        {
            this.gInterface = gInterface;
        }

        public void Write(ICodeWritter outFile)
        {
            this.outFile = outFile;
            openClass();
            MixinInterfaces();
            createConstructor();
            writeMethods();
            closeClass();
        }

        protected void openClass()
        {
            writeHeaderComment();
            outFile.Write("class {0}", this.gInterface.Name);
            if (this.gInterface.InterfacesImplemented.Count > 0)
                outFile.WriteNoIndent(" extends Module");
            outFile.WriteLine("");
            outFile.Indent();
        }

        protected void writeHeaderComment()
        {
            if (!string.IsNullOrWhiteSpace(this.gInterface.ClassComment))
            {
                BlockComment classComment = new BlockComment(this.outFile, 40);
                classComment.comment = this.gInterface.ClassComment;
                classComment.BeginComment = "#";
                classComment.EndComment = "#";
                classComment.CommentFill = '#';
                classComment.write();
            }
        }

        protected void MixinInterfaces()
        {
            foreach (Interface ginterface in gInterface.InterfacesImplemented)
            {
                outFile.WriteLine("@include {0}",ginterface.Name);
            }
        }

        protected void closeClass()
        {
            outFile.Unindent();
        }

        protected virtual void createConstructor()
        {
            outFile.WriteLine("constructor: ()->");
        }

        protected virtual void writeAllMemebers()
        {

        }

        private void writeMethods()
        {
            List<Method> allMethods = new List<Method>();
            allMethods.AddRange(this.gInterface.PublicMethods);

            foreach (Method method in allMethods)
            {
                writeMethod(method);
            }
        }
        protected void writeMethod(Method method)
        {
            BlockComment methodComment = new BlockComment(this.outFile, 40);
            methodComment.BeginComment = "#";
            methodComment.EndComment = "#";
            methodComment.comment = method.Comment;
            methodComment.write();

            if (this.gInterface.IsStatic)
                outFile.Write("@");

            outFile.WriteLineNoIndent("{0}: ({1})->", method.Name, buildArgumentString(method.Arguments));
            if (method.Overriding != null)
            {
                outFile.Indent();
                outFile.Write("super({0});", buildArgumentString(method.BaseClassArgs));
                outFile.Unindent();
            }
        }

        protected string buildArgumentString(List<Method.typeName> args)
        {
            if (args.Count > 0)
            {
                StringBuilder argString = new StringBuilder();
                argString.Append(args[0].name);
                for (int i = 1; i < args.Count; i++)
                {
                    Method.typeName metTypeName = args[i];
                    argString.Append(string.Format(",{0}", metTypeName.name));
                }
                return argString.ToString();
            }
            else
                return "";
        }

    }
   
}
