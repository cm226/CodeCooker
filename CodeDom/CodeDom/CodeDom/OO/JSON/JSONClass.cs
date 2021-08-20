using CodeDom.OO.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.JSON
{
    public class JSONClass : IWriteable
    {
        GenericClass gClass;
        ICodeWritter outFile;

        public JSONClass(GenericClass gClass)
        {
            this.gClass = gClass;
        }

        public void write(ICodeWritter codeWritter)
        {
            this.outFile = codeWritter;
            WriteOpenClass();
            WriteInheritedMembers();
            WriteClassContent();
            WriteCloseClass();
        }
        
        private void WriteOpenClass()
        {
            this.outFile.WriteLine("{{\"{0}\":{{",this.gClass.Name);
            this.outFile.Indent();
        }

        private void WriteInheritedMembers()
        {
            if(this.gClass.BaseClassSet)
            {
                JSONClass baseClass = new JSONClass(this.gClass.BaseClass);
                baseClass.write(this.outFile);
                if (this.gClass.PublicProperties.Count > 0)
                    this.outFile.WriteLineNoIndent(",");

            }

        }

        private void WriteClassContent()
        {
            int publicPropertysCount = this.gClass.PublicProperties.Count;
            foreach(Member member in this.gClass.PublicProperties)
            {
                this.outFile.Write("\"{0}\":\"\"",member.Name);
                publicPropertysCount--;
                if (publicPropertysCount > 0)
                    this.outFile.WriteNoIndent(",");

                this.outFile.WriteLine("");
            }
        }

        private void WriteCloseClass()
        {
            this.outFile.Unindent();
            this.outFile.Write("}}");
        }

    }
}
