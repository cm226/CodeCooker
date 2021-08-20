using System;
using System.IO;
using CodeDom.OO.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class CSBaseClassTest
    {
        [TestMethod]
        public void BaseClass()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.GenericClass baseClass = new CodeDom.OO.GenericClass("AbaseClass");

            gclass.setBaseClass(baseClass);
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
                Assert.AreEqual(filecontents.Contains("class member : AbaseClass"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void BaseClassWithNamespace()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.GenericClass baseClass = new CodeDom.OO.GenericClass("AbaseClass");
            baseClass.Namespaces.Add("one");
            baseClass.Namespaces.Add("two");
            baseClass.Namespaces.Add("three");

            gclass.setBaseClass(baseClass);
            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name + ".cs");
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("using one.two.three;"), true);
                Assert.AreEqual(filecontents.Contains("class member : AbaseClass"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }
    }
}
