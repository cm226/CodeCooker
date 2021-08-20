using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CS;
using System.IO;
using CodeDom.OO.Utils;
using CodeDomUnitTests.Utils;
using CodeDomUnitTests.OO.Exceptions;

namespace CodeDomUnitTests.OO.CS.Extreem
{
    [TestClass]
    public class MethodNames
    {
        [TestMethod]
        public void MethodNoArgs()
        {
            FolderCleaner.cleanFolder();

            GenericClass gc = new GenericClass("TestClass");
            Method member = new Method("testMethod");
            gc.PrivateMethods.Add(member);
            CSClass csClass = new CSClass(gc);

            bool excptThrown = false;
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cs");
            using (FileStream fs = File.Open(location.AbsolutePath, FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                try
                {
                    csClass.write(writer);
                }
                catch (InvalidNameException e)
                {
                    excptThrown = true;
                }
            }
            CSCompileChecker compileChecker = new CSCompileChecker();
            compileChecker.Check(location);

            Assert.AreEqual(excptThrown, false);
        }
    }
}
