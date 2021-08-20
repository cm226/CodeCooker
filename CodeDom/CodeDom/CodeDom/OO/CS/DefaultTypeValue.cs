using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    public class DefaultTypeValue : IDefaultTypeValue
    {

        public string defaultValue(Type t)
        {
            if (t == Types.DOUBLE || t == Types.FLOAT)
                return "0.0";
            else if (t == Types.INT)
                return "0";
            else if (t == Types.STRING)
                return "\"\"";
            else if (t == Types.VOID)
                return "";
            else if (t == Types.UNSPECIFIED)
                return "";

            else return "new " + t.StringValue+"()";
        }
    }
}
