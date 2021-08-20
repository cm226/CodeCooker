using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class ClassMemberArgumentTests
    {
        [TestMethod]
        public void singleArgument()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");

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
                Assert.AreEqual(filecontents.Contains("private int testMethod(int arg1)\r\n\t{\r\n\t\treturn 0;\r\n\t}"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }


        [TestMethod]
        public void doubleArgument()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");
            m.addArgs(CodeDom.Types.INT, "arg2");

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
                Assert.AreEqual(filecontents.Contains("private int testMethod(int arg1,int arg2)\r\n\t{\r\n\t\treturn 0;\r\n\t}"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }
    }
}
