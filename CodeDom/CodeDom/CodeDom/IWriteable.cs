using CodeDom.OO.Utils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom
{
    public interface IWriteable
    {
        void write(ICodeWritter codeWriter);
    }
}
