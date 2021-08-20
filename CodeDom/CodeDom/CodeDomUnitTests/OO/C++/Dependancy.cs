using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class Dependancy
    {
        [TestMethod]
        public void SingleStandardDependancyTest()
        {
            GenericClass gc = new GenericClass("testClass");
            CodeDom.Dependancy dep = new CodeDom.Dependancy();
            dep.StandardDependancy = CodeDom.Dependancy.StandardDependancyValue.STRING;
            gc.Dependancys.Add(dep);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("#include <string>"), true);
            }

        }
    }
}
