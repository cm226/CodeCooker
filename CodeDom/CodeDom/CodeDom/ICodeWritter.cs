using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Utils
{
    public interface ICodeWritter : IDisposable
    {
        void Indent();
        void Unindent();

        void Write(string value);
        void Write(string format, object arg0);
        void Write(string format, object arg0, object arg1);
        void Write(string format, object arg0, object arg1, object arg2);
        void Write(string format, params object[] arg);
        void WriteLine(string value);
        void WriteLine(string format, object arg0);
        void WriteLine(string format, object arg0, object arg1);
        void WriteLine(string format, object arg0, object arg1, object arg2);
        void WriteLine(string format, params object[] arg);

        void WriteNoIndent(string value);
        void WriteNoIndent(string format, object arg0);
        void WriteNoIndent(string format, object arg0, object arg1);
        void WriteNoIndent(string format, object arg0, object arg1, object arg2);
        void WriteNoIndent(string format, params object[] arg);
        void WriteLineNoIndent(string value);
        void WriteLineNoIndent(string format, object arg0);
        void WriteLineNoIndent(string format, object arg0, object arg1);
        void WriteLineNoIndent(string format, object arg0, object arg1, object arg2);
        void WriteLineNoIndent(string format, params object[] arg);

    }
}
