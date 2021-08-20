using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

// uses coffeesharp
namespace CodeDomUnitTests.OO.Coffeescript
{
    class CoffeescriptCompileChecker
    {
        public bool Check(string filePath)
        {

            CoffeeSharp.CoffeeScriptEngine cse = new CoffeeSharp.CoffeeScriptEngine();
            string coffeescript = File.ReadAllText(filePath);
            string js = cse.Compile(coffeescript);
            if (js.Contains("error"))
                return false;

            return true;
        }
        }
}
