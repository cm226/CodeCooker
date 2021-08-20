using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class Namespace
    {
        [TestMethod]
        public void SingleNamespace()
        {
            GenericClass gc = new GenericClass("testClass");
            gc.Namespaces.Add("TestNamespace");

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\TestNamespace");

            cppClass.write(location.AbsolutePath);
            cppheader.write(location.AbsolutePath);

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Uri ResolvedLocation = new Uri(location.AbsolutePath + "\\testClass.cpp");
            Assert.AreEqual(compileChecker.Compiles(ResolvedLocation), true);

            using (StreamReader header = File.OpenText(location.AbsolutePath + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("namespace TestNamespace {"), true);
            }

            using (StreamReader header = File.OpenText(location.AbsolutePath + "\\testClass.cpp"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("namespace TestNamespace {"), true);
            }
        }

        [TestMethod]
        public void SingleNamespaceWithMethod()
        {
            GenericClass gc = new GenericClass("testClass");
            gc.Namespaces.Add("TestNamespace");
            gc.PublicMethods.Add(new Method("method"));

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\TestNamespace");

            cppClass.write(location.AbsolutePath);
            cppheader.write(location.AbsolutePath);

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Uri ResolvedLocation = new Uri(location.AbsolutePath + "\\testClass.cpp");
            Assert.AreEqual(compileChecker.Compiles(ResolvedLocation), true);

            using (StreamReader header = File.OpenText(location.AbsolutePath + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("namespace TestNamespace {"), true);
                Assert.AreEqual(headerContent.Contains("method();"), true);
            }

            using (StreamReader header = File.OpenText(location.AbsolutePath + "\\testClass.cpp"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("namespace TestNamespace {"), true);
                Assert.AreEqual(headerContent.Contains("testClass::method()"), true);
            }
        }
    }
}
