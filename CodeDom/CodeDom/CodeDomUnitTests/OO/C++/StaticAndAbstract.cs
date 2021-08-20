using System;
using System.IO;
using CodeDom.OO;
using CodeDom.OO.CPP;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class StaticAndAbstract
    {
        [TestMethod]
        public void ClassWithStaticMethod()
        {
            GenericClass gc = new GenericClass("testClass");
            Method method = new Method("intMethod");
            gc.PublicMethods.Add(method);
            method.Static = true;

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("static void intMethod();"), true);
            }
        }

        [TestMethod]
        public void ClassWithAbstractMethod()
        {
            GenericClass gc = new GenericClass("testClass");
            Method method = new Method("intMethod");
            gc.PublicMethods.Add(method);
            method.Abstract = true;

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("virtual void intMethod() = 0;\r\n"), true);
            }

            using (StreamReader body = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.cpp"))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("intMethod()"), false);
            }
        }

        [TestMethod]
        public void ClassWithAbstractAndStaticMethod()
        {
            GenericClass gc = new GenericClass("testClass");
            Method method = new Method("intMethod");
            gc.PublicMethods.Add(method);
            method.Abstract = true;
            method.Static = true;

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("static void intMethod();\r\n"), true);
            }
        }
    }
}
