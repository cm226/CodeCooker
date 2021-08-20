using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Utils
{
    public class CodeWritter : ICodeWritter, IDisposable
    {
        private StreamWriter writer;
        private string indentPrefix = "";

        public CodeWritter(string path)
        {
            this.writer = new StreamWriter(path);
        }

        public CodeWritter(Stream stream)
        {
            this.writer = new StreamWriter(stream);
        }

        public void Indent()
        {
            this.indentPrefix = string.Format("{1}{0}", this.indentPrefix, "\t");
        }

        public void Unindent()
        {
            if(this.indentPrefix.Length > 0)
                indentPrefix = this.indentPrefix.Remove(0, 1);
        }

        public void Flush()
        {
            writer.Flush();
        }

        #region Write Overrides
        public void Write(string value)
        {
            writer.Write(string.Format("{0}{1}",this.indentPrefix,value));
        }

        public void Write(string format, object arg0)
        {
            writer.Write(string.Format("{0}{1}", this.indentPrefix, format), arg0);
        }

        public void Write(string format, object arg0, object arg1)
        {
            writer.Write(string.Format("{0}{1}", this.indentPrefix, format), arg0, arg1);
        }

        public void Write(string format, object arg0, object arg1, object arg2)
        {
            writer.Write(string.Format("{0}{1}", this.indentPrefix, format), arg0, arg1, arg2);
        }

        public void Write(string format, params object[] arg)
        {
            writer.Write(string.Format("{0}{1}", this.indentPrefix, format), arg);
        }

        #endregion
        #region WriteLine Overrides

        public void WriteLine(string value)
        {
            writer.WriteLine(string.Format("{0}{1}", this.indentPrefix, value));
        }

        public void WriteLine(string format, object arg0)
        {
            writer.WriteLine(string.Format("{0}{1}", this.indentPrefix, format), arg0);
        }

        public void WriteLine(string format, object arg0, object arg1)
        {
            writer.WriteLine(string.Format("{0}{1}", this.indentPrefix, format), arg0, arg1);
        }

        public void WriteLine(string format, object arg0, object arg1, object arg2)
        {
            writer.WriteLine(string.Format("{0}{1}", this.indentPrefix, format), arg0, arg1, arg2);
        }

        public void WriteLine(string format, params object[] arg)
        {
            writer.WriteLine(string.Format("{0}{1}", this.indentPrefix, format), arg);
        }
        #endregion
        #region Noindent
        public void WriteNoIndent(string value)
        {
            writer.Write(value);
        }

        public void WriteNoIndent(string format, object arg0)
        {
            writer.Write(format, arg0);
        }

        public void WriteNoIndent(string format, object arg0, object arg1)
        {
            writer.Write(format, arg0, arg1);
        }

        public void WriteNoIndent(string format, object arg0, object arg1, object arg2)
        {
            writer.Write(format, arg0, arg1, arg2);
        }

        public void WriteNoIndent(string format, params object[] arg)
        {
            writer.Write(format, arg);
        }

        public void WriteLineNoIndent(string value)
        {
            writer.WriteLine(value);
        }

        public void WriteLineNoIndent(string format, object arg0)
        {
            writer.WriteLine(format, arg0);
        }

        public void WriteLineNoIndent(string format, object arg0, object arg1)
        {
            writer.WriteLine(format, arg0, arg1);
        }

        public void WriteLineNoIndent(string format, object arg0, object arg1, object arg2)
        {
            writer.WriteLine(format, arg0, arg1, arg2);
        }

        public void WriteLineNoIndent(string format, params object[] arg)
        {
            writer.WriteLine(format, arg);
        }
        #endregion

        public void Dispose()
        {
            writer.Dispose();
        }

        void IDisposable.Dispose()
        {
            writer.Dispose();
        }
    }
}
