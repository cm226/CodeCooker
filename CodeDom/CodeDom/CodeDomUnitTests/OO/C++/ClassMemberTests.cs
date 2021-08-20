using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class ClassMemberTests
    {
        [TestMethod]
        public void publicMemberTest()
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
            }
        }


        [TestMethod]
        public void privateMemberTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Member member = new Member(CodeDom.Types.INT, "intMember");
            gc.PrivateProperties.Add(member);

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
                Assert.AreEqual(headerContent.Contains("private:\r\n\t\t\tint intMember;"), true);
            }
        }

        [TestMethod]
        public void protectedMemberTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Member member = new Member(CodeDom.Types.INT, "intMember");
            gc.ProtectedProperties.Add(member);

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
                Assert.AreEqual(headerContent.Contains("protected:\r\n\t\t\tint intMember;\r\n"), true);
            }
        }

        [TestMethod]
        public void multiMemberTest()
        {
            GenericClass gc = new GenericClass("testClass");
            Member member = new Member(CodeDom.Types.INT, "intMember");
            Member member2 = new Member(CodeDom.Types.FLOAT, "floatMember");
            gc.ProtectedProperties.Add(member);
            gc.ProtectedProperties.Add(member2);

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
                Assert.AreEqual(headerContent.Contains("protected:\r\n\t\t\tint intMember;\r\n\t\t\tfloat floatMember;"), true);
            }
        }
    }
}
