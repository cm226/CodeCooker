using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;
using CodeDomUnitTests.OO.Exceptions;

namespace CodeDomUnitTests.OO.C__.Extreem
{
    [TestClass]
    public class ClassName
    {
        [TestMethod]
        public void ClassNameWithSpace()
        {
            GenericClass gc = new GenericClass("test Class");
            bool exceptThrown = false;
            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            try
            {
                cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
                cppheader.write(Path.GetDirectoryName(location.AbsolutePath));
            }
            catch(InvalidNameException excpt)
            {
                exceptThrown = true;
            }

            Assert.AreEqual(exceptThrown, true);
        }

        [TestMethod]
        public void ClassNameWithBracket()
        {
            bool exceptThrown = false;
            GenericClass gc = new GenericClass("test}Class");

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            try
            {
                cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
                cppheader.write(Path.GetDirectoryName(location.AbsolutePath));
            }
            catch (InvalidNameException excp)
            {
                exceptThrown = true;
            }
            Assert.AreEqual(exceptThrown, true);
        }

        [TestMethod]
        public void ClassNameEmpty()
        {
            GenericClass gc = new GenericClass("");

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\unNamedClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            CPPCompileChecker compileChecker = new CPPCompileChecker();
            Assert.AreEqual(compileChecker.Compiles(location), true);

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\unNamedClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class unNamedClass"), true);
            }

            using (StreamReader body = File.OpenText(location.AbsolutePath))
            {
                string bodyContent = body.ReadToEnd();
                Assert.AreEqual(bodyContent.Contains("unNamedClass::unNamedClass()"), true);
            }
        }

        [TestMethod]
        public void ClassNameReallyBad()
        {
            GenericClass gc = new GenericClass("hell-:ow{}%w£)(*&^%!=_`¬|\"'or ld");

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            bool exceptionThrown = false;
            try
            {
                cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
                cppheader.write(Path.GetDirectoryName(location.AbsolutePath));
            }
            catch(InvalidNameException ext)
            {
                exceptionThrown = true;
            }
            Assert.AreEqual(exceptionThrown, true);

        }
    }
}
