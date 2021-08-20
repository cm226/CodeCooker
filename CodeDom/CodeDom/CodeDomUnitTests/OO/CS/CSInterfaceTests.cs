using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class CSInterfaceTests
    {
        [TestMethod]
        public void InterfaceSingleMethod()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.Interface ginterface = new CodeDom.OO.Interface("testInterface");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");

            ginterface.PublicMethods.Add(m);
            CodeDom.OO.CS.CSInterface csInterface= new CodeDom.OO.CS.CSInterface(ginterface);
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
                Assert.AreEqual(filecontents.Contains("interface testInterface\r\n{\r\n\tint testMethod(int arg1);\r\n}\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }


        [TestMethod]
        public void InterfaceNoMethods()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.Interface ginterface = new CodeDom.OO.Interface("testInterface");
            CodeDom.OO.Method m = new CodeDom.OO.Method("testMethod");
            m.Return = CodeDom.Types.INT;
            m.addArgs(CodeDom.Types.INT, "arg1");

            CodeDom.OO.Method m2 = new CodeDom.OO.Method("testMethod2");
            m2.Return = CodeDom.Types.INT;
            m2.addArgs(CodeDom.Types.INT, "arg1");
            m2.addArgs(CodeDom.Types.STRING, "arg2");

            ginterface.PublicMethods.Add(m);
            ginterface.PublicMethods.Add(m2);
            CodeDom.OO.CS.CSInterface csInterface = new CodeDom.OO.CS.CSInterface(ginterface);
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
                Assert.AreEqual(filecontents.Contains("interface testInterface\r\n{\r\n\tint testMethod(int arg1);\r\n\tint testMethod2(int arg1,string arg2);\r\n}\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }


        [TestMethod]
        public void InterfaceMultipleMethods()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.Interface ginterface = new CodeDom.OO.Interface("testInterface");

            CodeDom.OO.CS.CSInterface csInterface = new CodeDom.OO.CS.CSInterface(ginterface);
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
                Assert.AreEqual(filecontents.Contains("interface testInterface\r\n{\r\n}\r\n"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }
    }
}
