using CodeDom.OO.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDomUnitTests.Utils
{
    public class StubCodeWritter : ICodeWritter
    {
        public StringBuilder Content = new StringBuilder();
        public void Indent()
        {
            
        }

        public void Unindent()
        {
            
        }

        public void Write(string value)
        {
            this.Content.Append(value);
        }

        public void Write(string format, object arg0)
        {
            this.Content.AppendFormat(format, arg0);
        }

        public void Write(string format, object arg0, object arg1)
        {
            this.Content.AppendFormat(format, arg0, arg1);
        }

        public void Write(string format, object arg0, object arg1, object arg2)
        {
            this.Content.AppendFormat(format, arg0, arg1, arg2);
        }

        public void Write(string format, params object[] arg)
        {
            this.Content.AppendFormat(format, arg);
        }

        public void WriteLine(string value)
        {
            this.Content.AppendLine(value);
        }

        public void WriteLine(string format, object arg0)
        {
            this.Content.AppendLine(string.Format(format, arg0));
        }

        public void WriteLine(string format, object arg0, object arg1)
        {
            this.Content.AppendLine(string.Format(format, arg0,arg1));
        }

        public void WriteLine(string format, object arg0, object arg1, object arg2)
        {
            this.Content.AppendLine(string.Format(format, arg0, arg1,arg2));
        }

        public void WriteLine(string format, params object[] arg)
        {
            this.Content.AppendLine(string.Format(format, arg));
        }

        public void WriteNoIndent(string value)
        {
            this.Content.Append(value);
        }

        public void WriteNoIndent(string format, object arg0)
        {
            this.Content.AppendFormat(format, arg0);
        }

        public void WriteNoIndent(string format, object arg0, object arg1)
        {
            this.Content.AppendFormat(format, arg0, arg1);
        }

        public void WriteNoIndent(string format, object arg0, object arg1, object arg2)
        {
            this.Content.AppendFormat(format, arg0, arg1, arg2);
        }

        public void WriteNoIndent(string format, params object[] arg)
        {
            this.Content.AppendFormat(format, arg);
        }

        public void WriteLineNoIndent(string value)
        {
            this.Content.Append(value);
        }

        public void WriteLineNoIndent(string format, object arg0)
        {
            this.Content.AppendFormat(format, arg0);
        }

        public void WriteLineNoIndent(string format, object arg0, object arg1)
        {
            this.Content.AppendFormat(format, arg0, arg1);   
        }

        public void WriteLineNoIndent(string format, object arg0, object arg1, object arg2)
        {
            this.Content.AppendFormat(format, arg0, arg1, arg2);
        }

        public void WriteLineNoIndent(string format, params object[] arg)
        {
            this.Content.AppendFormat(format, arg);
        }

        public void Dispose()
        {
            
        }
    }
}
