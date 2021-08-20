using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CS;
using System.IO;
using CodeDomUnitTests.OO.Exceptions;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.CS.Extreem
{
    [TestClass]
    public class MemberNames
    {
        [TestMethod]
        public void MethodNameWithSpace()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "test Method");
            gc.PrivateProperties.Add(member);

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
                catch(InvalidNameException e)
                {
                    excptThrown = true;
                }

            }

            Assert.AreEqual(excptThrown, true);

        }


        [TestMethod]
        public void MethodNameEmpty()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "");
            gc.PrivateProperties.Add(member);

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
                Assert.AreEqual(filecontents.Contains("private int noName;\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);

        }


        [TestMethod]
        public void MethodNameWithBracket()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "test{Method");
            gc.PrivateProperties.Add(member);

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
                catch(InvalidNameException exc)
                {
                    excptThrown = true;
                }

            }

            Assert.AreEqual(excptThrown, true);
        }

        [TestMethod]
        public void MethodNameReallyBad()
        {
            GenericClass gc = new GenericClass("TestClass");
            Member member = new Member(CodeDom.Types.INT, "test{Me)(.{!\"£$%^&*()¬`thod");
            gc.PrivateProperties.Add(member);

            CSClass csClass = new CSClass(gc);

            bool exceptionThrown = false;
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cs");
            using (FileStream fs = File.Open(location.AbsolutePath, FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                try
                {
                    csClass.write(writer);
                }
                catch(InvalidNameException exp)
                {
                    exceptionThrown = true;
                }
                writer.Flush();

            }

            Assert.AreEqual(exceptionThrown, true);

        }
    }
}
