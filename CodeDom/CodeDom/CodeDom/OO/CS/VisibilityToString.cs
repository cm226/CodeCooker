using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    public class VisibilityToString
    {
        public static string convert(CodeDom.OO.Interface.Visibility visibilty )
        {
            switch(visibilty)
            {
                case Interface.Visibility.PRIVATE:
                    return "private";
                case Interface.Visibility.PROTECTED:
                    return "protected";
                default:
                    return "public";
            }
        }
    }
}
