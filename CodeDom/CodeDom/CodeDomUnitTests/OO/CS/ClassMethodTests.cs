using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class ClassMethodTests
    {
        [TestMethod]
        public void SinglePublicMember()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;

            gclass.PublicMethods.Add(m);
            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName+"\\"+gclass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public int testMethod()\r\n\t{\r\n\t\treturn 0;\r\n\t}"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void SinglePrivateMember()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;

            gclass.PrivateMethods.Add(m);
            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("private int testMethod()\r\n\t{\r\n\t\treturn 0;\r\n\t}"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void SingleProtectedMember()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;

            gclass.ProtectedMethods.Add(m);
            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("protected int testMethod()\r\n\t{\r\n\t\treturn 0;\r\n\t}"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void MultiMember()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            CodeDom.OO.Method m2 = new CodeDom.OO.Method("testMethod2");
            m.Return = CodeDom.Types.INT;
           
            gclass.ProtectedMethods.Add(m);
            gclass.ProtectedMethods.Add(m2);
            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name+".cs");
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("protected int testMethod()\r\n\t{\r\n\t\treturn 0;\r\n\t}\r\n\tprotected void testMethod2()\r\n\t{\r\n\t}"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

    }
}
