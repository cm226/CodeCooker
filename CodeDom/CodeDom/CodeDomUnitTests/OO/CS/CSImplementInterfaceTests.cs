using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class CSImplementInterfaceTests 
    {
        [TestMethod]
        public void SingleInterface()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gClass = new CodeDom.OO.GenericClass("InterfaceImplementer");
            CodeDom.OO.Interface interfaceToImplemnt = new CodeDom.OO.Interface("Ainterface");

            gClass.ImplementInterface(interfaceToImplemnt);
            CodeDom.OO.CS.CSInterface csClass = new CodeDom.OO.CS.CSClass(gClass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gClass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("class InterfaceImplementer : Ainterface"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void MultipleInterfaces()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gClass = new CodeDom.OO.GenericClass("InterfaceImplementer");
            CodeDom.OO.Interface interfaceToImplemnt = new CodeDom.OO.Interface("Ainterface");
            CodeDom.OO.Interface interfaceToImplemnt2 = new CodeDom.OO.Interface("Ainterface2");

            gClass.ImplementInterface(interfaceToImplemnt);
            gClass.ImplementInterface(interfaceToImplemnt2);

            CodeDom.OO.CS.CSInterface csClass = new CodeDom.OO.CS.CSClass(gClass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gClass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("class InterfaceImplementer : Ainterface, Ainterface2"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void InterfaceAndBaseClass()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gClass = new CodeDom.OO.GenericClass("InterfaceImplementer");
            CodeDom.OO.Interface interfaceToImplemnt = new CodeDom.OO.Interface("Ainterface");
            CodeDom.OO.GenericClass baseClass = new CodeDom.OO.GenericClass("baseClass");

            gClass.ImplementInterface(interfaceToImplemnt);
            gClass.setBaseClass(baseClass);

            CodeDom.OO.CS.CSInterface csClass = new CodeDom.OO.CS.CSClass(gClass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gClass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("class InterfaceImplementer : baseClass ,Ainterface"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }


        [TestMethod]
        public void SingleInterfaceWithNamespace()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gClass = new CodeDom.OO.GenericClass("InterfaceImplementer");
            CodeDom.OO.Interface interfaceToImplemnt = new CodeDom.OO.Interface("Ainterfcae");
            interfaceToImplemnt.Namespaces.Add("one");
            interfaceToImplemnt.Namespaces.Add("two");
            interfaceToImplemnt.Namespaces.Add("three");

            gClass.ImplementInterface(interfaceToImplemnt);
            CodeDom.OO.CS.CSInterface csClass = new CodeDom.OO.CS.CSClass(gClass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gClass.Name);
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
                Assert.AreEqual(filecontents.Contains("class InterfaceImplementer : Ainterfcae"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }
    }
}
