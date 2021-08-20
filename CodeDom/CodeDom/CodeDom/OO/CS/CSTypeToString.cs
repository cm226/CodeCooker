using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    class CSTypeToString
    {
        public string ConvertType(Type type)
        {
                if (type.StringValue != null)
                {
                    return type.StringValue;
                }

                if (type == Types.DOUBLE)
                    return "double";
                if (type == Types.FLOAT)
                    return "float";
                if (type == Types.INT)
                    return "int";
                if (type == Types.STRING)
                    return "string";
                if (type == Types.VOID)
                    return "void";
                if (type == Types.UNSPECIFIED)
                    return "";
                if (type == Types.BOOLEAN)
                    return "bool";
                if (type == Types.TIME || type == Types.DATE || type == Types.DATETIME)
                    return "DateTime";

                throw new ArgumentExeption("the type is not suported: " + type);
            }
    }
}
