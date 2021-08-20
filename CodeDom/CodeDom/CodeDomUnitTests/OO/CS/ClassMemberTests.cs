using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CS;
using System.IO;
using CodeDom.OO.Utils;
using CodeDomUnitTests.Utils;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class ClassMemberTests
    {
        [TestMethod]
        public void PrivateMemberTest()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "testMethod");
            gc.PrivateProperties.Add(member);

            CSClass csClass = new CSClass(gc);
            

            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cs");
            using(FileStream fs = File.Open(location.AbsolutePath,FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();
                
                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("private int testMethod;\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }


        [TestMethod]
        public void PublicMemberTest()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "testMethod");
            gc.PublicProperties.Add(member);

            CSClass csClass = new CSClass(gc);


            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cs");
            using (FileStream fs = File.Open(location.AbsolutePath, FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public int testMethod;\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }

        [TestMethod]
        public void ProtectedMemberTest()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "testMethod");
            gc.ProtectedProperties.Add(member);

            CSClass csClass = new CSClass(gc);


            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cs");
            using (FileStream fs = File.Open(location.AbsolutePath, FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("protected int testMethod;\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }



        [TestMethod]
        public void MultiMemberTest()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "testMethod");
            Member member2 = new Member(CodeDom.Types.STRING, "testMethod2");

            gc.ProtectedProperties.Add(member);
            gc.ProtectedProperties.Add(member2);

            CSClass csClass = new CSClass(gc);

            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cs");
            using (FileStream fs = File.Open(location.AbsolutePath, FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("protected int testMethod;\r\n\tprotected string testMethod2;\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }
        
        [TestMethod]
        public void StaticMemberTest()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "testMethod");
            member.IsStatic = true;

            gc.PrivateProperties.Add(member);

            CSClass csClass = new CSClass(gc);

            CodeContainsTest containsTest = new CodeContainsTest();
            containsTest.Lines.Add("private static int testMethod;");

            Assert.AreEqual(containsTest.Contains(gc, csClass), true);
        }
    }
}
