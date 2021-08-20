using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class ClassMethodTests
    {
        [TestMethod]
        public void singleMethodTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Method m = new Method("testMethod");
            gc.PrivateMethods.Add(m);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader body = File.OpenText(location.AbsolutePath))
            {
                string bodyContent = body.ReadToEnd();
                string test = "void testClass::testMethod()";
                Assert.AreEqual(bodyContent.Contains(test), true);
            }

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath)+"\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("private:\r\n\t\t\tvoid testMethod();"), true);
            }
        }

        [TestMethod]
        public void multiMethodTest()
        {
                GenericClass gc = new GenericClass("testClass");
                Method m = new Method("testMethod");
                Method m2 = new Method("testMethod2");
                gc.PrivateMethods.Add(m);
                gc.PrivateMethods.Add(m2);

                CppClass cppClass = new CppClass(gc);
                CppHeader cppheader = new CppHeader(gc);
                Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

                cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
                cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

                CPPCompileChecker compileChecker = new CPPCompileChecker();
                Assert.AreEqual(compileChecker.Compiles(location), true);

                using (StreamReader body = File.OpenText(location.AbsolutePath))
                {
                    string bodyContent = body.ReadToEnd();
                    Assert.AreEqual(bodyContent.Contains("void testClass::testMethod()"), true);
                    Assert.AreEqual(bodyContent.Contains("void testClass::testMethod2()"), true);
                }

                using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
                {
                    string headerContent = header.ReadToEnd();
                    Assert.AreEqual(headerContent.Contains("private:\r\n\t\t\tvoid testMethod();\r\n\t\t\tvoid testMethod2();"), true);
                }
        }

        [TestMethod]
        public void publicMethodTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Method m = new Method("testMethod");
            
            gc.PublicMethods.Add(m);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader body = File.OpenText(location.AbsolutePath))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("testClass::testMethod()\r\n{\r\n\t\r\n}"), true);
            }

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("void testMethod();\r\n"), true);
            }
        }

        [TestMethod]
        public void protectedMethodTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Method m = new Method("testMethod");

            gc.ProtectedMethods.Add(m);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader body = File.OpenText(location.AbsolutePath))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("testClass::testMethod()\r\n{\r\n\t\r\n}"), true);
            }

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("protected:\r\n\t\t\tvoid testMethod();"), true);
            }
        }

    }
}
