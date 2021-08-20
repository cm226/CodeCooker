using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CodeDom.OO.CS
{
    public class Utils
    {
        static Regex validNameRexEx = new Regex("^[A-Za-z]+[0-9[A-Za-z]*$");

        public static bool validName(string name)
        {
            return validNameRexEx.IsMatch(name);
        }
    }
}
