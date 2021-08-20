using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CodeDom.OO.C__
{
    public static class Utils
    {
        private static Regex invalidName = new Regex("[\\[\\] \\{\\}!\"',£$%^^&\\\\*\\(\\)]");

        public static bool validCPPname(string name)
        {
            return !invalidName.IsMatch(name);

        }
    }
}
