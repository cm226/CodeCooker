using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDomUnitTests.Utils
{
    public class GlobalConstants
    {
        public static System.IO.DirectoryInfo testFolder =
            new System.IO.DirectoryInfo(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TestData\TempTestFolder");
        public static System.IO.DirectoryInfo buildFolder =
            new System.IO.DirectoryInfo(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TestData");
    }
}
