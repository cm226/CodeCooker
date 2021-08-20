using System;
using System.IO;
using CodeDom.OO;
using CodeDom.OO.CS;
using CodeDom.OO.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class Namespaces
    {

        [TestMethod]
        public void NoNamespace()
        {
            GenericClass gc = new GenericClass("TestClass");

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
                Assert.AreEqual(filecontents.Contains("namespace"), false);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }

        [TestMethod]
        public void InvalidNamespaceName()
        {
            GenericClass gc = new GenericClass("TestClass");
            gc.Namespaces.Add("namespace with space");
            gc.Namespaces.Add("namespacewith%");
            gc.Namespaces.Add("namespacewith.init");
            gc.Namespaces.Add("namespacewith*init");
            gc.Namespaces.Add("");
            gc.Namespaces.Add("namespacewit7hinit");
            gc.Namespaces.Add("85757");
            gc.Namespaces.Add("8hfjshjks");

            Utils.CodeContainsTest containsTest = new Utils.CodeContainsTest();
            containsTest.Lines.Add("namespace_with_space");
            containsTest.Lines.Add("namespacewith_");
            containsTest.Lines.Add("namespacewith_init");
            containsTest.Lines.Add("namespacewit7hinit");
            containsTest.Lines.Add("_85757");
            containsTest.Lines.Add("_8hfjshjks");

            bool testpasses = containsTest.Contains(gc, new CSClass(gc));
            Assert.AreEqual(testpasses, true);
            
            
        }

        [TestMethod]
        public void SingleNamespace()
        {
            GenericClass gc = new GenericClass("TestClass");
            gc.Namespaces.Add("testNS");
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
                Assert.AreEqual(filecontents.Contains("namespace testNS"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }


        [TestMethod]
        public void MultipuleNamespace()
        {
            GenericClass gc = new GenericClass("TestClass");
            gc.Namespaces.Add("testNS");
            gc.Namespaces.Add("testNS2");
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
                Assert.AreEqual(filecontents.Contains("namespace testNS.testNS2"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(location), true);
        }

    }
}
