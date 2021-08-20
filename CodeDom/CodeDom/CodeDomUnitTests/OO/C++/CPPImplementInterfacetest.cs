using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;
using CodeDom.OO.C__;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class CPPImplementInterfacetest
    {
        [TestMethod]
        public void ImplementInterface()
        {
            GenericClass gc = new GenericClass("testClass");
            Interface interfc = new Interface("Ainterface");
            gc.ImplementInterface(interfc);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class testClass : public Ainterface"), true);
                Assert.AreEqual(headerContent.Contains("#include \"Ainterface.h\""), true);
            }

            using (StreamReader body = File.OpenText(location.AbsolutePath))
            {
                string bodyContent = body.ReadToEnd();
            }

            CPPCompileChecker compileCeker = new CPPCompileChecker();
            compileCeker.Compiles(location);
        }

        [TestMethod]
        public void ImplementInterfaceWithNamespace()
        {
            GenericClass gc = new GenericClass("testClass");
            Interface interfc = new Interface("Ainterface");
            interfc.Namespaces.Add("one");
            interfc.Namespaces.Add("two");
            interfc.Namespaces.Add("three");
            gc.ImplementInterface(interfc);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class testClass : public one::two::three::Ainterface"), true);
                Assert.AreEqual(headerContent.Contains("#include \"one\\two\\three\\Ainterface.h\""), true);
            }


            CPPCompileChecker compileCeker = new CPPCompileChecker();
            compileCeker.Compiles(location);
        }

        [TestMethod]
        public void ImplementInterfaceAndBaseClassWith()
        {
            GenericClass gc = new GenericClass("testClass");
            Interface interfc = new Interface("Ainterface");
            GenericClass baseClass = new GenericClass("baseClass");

            gc.setBaseClass(baseClass);
            gc.ImplementInterface(interfc);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class testClass : public baseClass, public Ainterface"), true);
                Assert.AreEqual(headerContent.Contains("#include \"baseClass.h\"\r\n\t#include \"Ainterface.h\""), true);
            }


            CPPCompileChecker compileCeker = new CPPCompileChecker();
            compileCeker.Compiles(location);
        }

        [TestMethod]
        public void ImplementMultipulInterfaces()
        {
            GenericClass gc = new GenericClass("testClass");
            Interface interfc = new Interface("Ainterface");
            interfc.Namespaces.Add("one");
            Interface interfc2 = new Interface("Ainterface2");
            interfc2.Namespaces.Add("two");
            
            
            gc.ImplementInterface(interfc);
            gc.ImplementInterface(interfc2);

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));
            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class testClass : public one::Ainterface, public two::Ainterface2"), true);
                Assert.AreEqual(headerContent.Contains("#include \"one\\Ainterface.h\"\r\n\t#include \"two\\Ainterface2.h\""), true);
            }


            CPPCompileChecker compileCeker = new CPPCompileChecker();
            compileCeker.Compiles(location);
        }


        [TestMethod]
        public void InterfaceImplementInterface()
        {
            Interface gc = new Interface("interfaceBase");
            Interface interfc = new Interface("Ainterface");
            interfc.Namespaces.Add("one");
            gc.Namespaces.Add("two");

            gc.ImplementInterface(interfc);

            CPPInterface cppInterface = new CPPInterface(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppInterface.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\two\\interfaceBase.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class interfaceBase : public one::Ainterface"), true);
                Assert.AreEqual(headerContent.Contains("#include \"..\\one\\Ainterface.h\""), true);
            }


            CPPCompileChecker compileCeker = new CPPCompileChecker();
            compileCeker.Compiles(location);
        }
    }
}
