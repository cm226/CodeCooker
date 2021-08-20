using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;
using CodeDom;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class Constructor
    {
        [TestMethod]
        public void DefaultConstructorDeconstructorTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Member member = new Member(CodeDom.Types.INT, "intMember");
            gc.PublicProperties.Add(member);

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
                Assert.AreEqual(headerContent.Contains("public:\r\n\t\t\tint intMember;"), true);
                Assert.AreEqual(headerContent.Contains("public:\r\n\t\t\ttestClass::testClass();\r\n\t\t\ttestClass::~testClass();"), true);
            }

            using (StreamReader body = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.cpp"))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("testClass::testClass()\r\n{\r\n\t\r\n}\r\ntestClass::~testClass()\r\n{\r\n\t\r\n}"), true);
            }
        }


        [TestMethod]
        public void DefaultConstructorDeconstructorOverrideTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Method ctor = new Method("testClass");
            ctor.Arguments.Add(new Method.typeName() { name = "arg1", t = Types.INT });
            Assert.AreEqual(gc.ConstructorSet, false);
            gc.Constructor = ctor;
            Assert.AreEqual(gc.ConstructorSet, true);

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
                Assert.AreEqual(headerContent.Contains("public:\r\n\t\t\ttestClass::testClass(int arg1);\r\n\t\t\ttestClass::~testClass();"), true);
            }
            using (StreamReader body = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.cpp"))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("testClass::testClass(int arg1)\r\n{\r\n\t\r\n}\r\ntestClass::~testClass()\r\n{\r\n\t\r\n}"), true);
            }
        }

        [TestMethod]
        public void ConstructorWithOddName()
        {
            GenericClass gc = new GenericClass("testClass");
            Method ctor = new Method("constructor");
            ctor.Arguments.Add(new Method.typeName() { name = "arg1", t = Types.INT });
            Assert.AreEqual(gc.ConstructorSet, false);
            gc.Constructor = ctor;
            Assert.AreEqual(gc.ConstructorSet, true);

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
                Assert.AreEqual(headerContent.Contains("public:\r\n\t\t\ttestClass::testClass(int arg1);\r\n\t\t\ttestClass::~testClass();"), true);
            }
            using (StreamReader body = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.cpp"))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("testClass::testClass(int arg1)\r\n{\r\n\t\r\n}\r\ntestClass::~testClass()\r\n{\r\n\t\r\n}"), true);
            }
        }

    }
}
