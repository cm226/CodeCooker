using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeDom.OO.Utils;

namespace CodeDom.OO.CS
{
    class CSConstructor : CSMethod
    {
        public CSConstructor(ICodeWritter writer) : base(writer)
        {

        }

        public void WriteConstructr(Method ctor)
        {
            this.outFile.Write("public {0}(", ctor.Name);
            this.writeArguments(ctor.Arguments);
            this.outFile.WriteLineNoIndent(")");
            if (ctor.BaseClassArgs.Count > 0)
            {
                this.outFile.Indent();
                this.outFile.Write(":base(");
                string[] argArr = new string[ctor.BaseClassArgs.Count];

                for (int i = 0; i < ctor.BaseClassArgs.Count; i++)
                    argArr[i] = String.Format("{0}", ctor.BaseClassArgs[i].name);

                this.outFile.WriteNoIndent(String.Join(",", argArr));
                this.outFile.WriteLineNoIndent(")");
                this.outFile.Unindent();
            }
            this.outFile.WriteLine("{");
            this.outFile.WriteLine("");
            this.outFile.WriteLine("}");
        }
    }
}
