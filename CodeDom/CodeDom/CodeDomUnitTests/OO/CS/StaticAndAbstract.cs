using System;
using System.IO;
using CodeDom.OO.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CS;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class StaticAndAbstract
    {
        [TestMethod]
        public void ClassWithSaticMethod()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass ginterface = new CodeDom.OO.GenericClass("test");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");
            m.Static = true;

            ginterface.PublicMethods.Add(m);
            CodeDom.OO.CS.CSClass csInterface = new CodeDom.OO.CS.CSClass(ginterface);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + ginterface.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csInterface.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public static int testMethod(int arg1)"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void ClassWithAbstractMethod()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass ginterface = new CodeDom.OO.GenericClass("test");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");
            m.Abstract = true;

            ginterface.PublicMethods.Add(m);
            CodeDom.OO.CS.CSClass csInterface = new CodeDom.OO.CS.CSClass(ginterface);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + ginterface.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csInterface.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public abstract int testMethod(int arg1);"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void ClassWithAbstractAndstaticMethod()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass ginterface = new CodeDom.OO.GenericClass("test");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");
            m.Abstract = true;
            m.Static = true;

            ginterface.PublicMethods.Add(m);
            CodeDom.OO.CS.CSClass csInterface = new CodeDom.OO.CS.CSClass(ginterface);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + ginterface.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csInterface.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public static int testMethod(int arg1);"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void StaticClass()
        {
            GenericClass gc = new GenericClass("class");
            gc.IsStatic = true;

            CSClass writter = new CSClass(gc);

            Utils.CodeContainsTest test = new Utils.CodeContainsTest();
            test.Lines.Add("public static class class");

            Assert.AreEqual(test.Contains(gc, writter), true);
        }
        
    }
}
