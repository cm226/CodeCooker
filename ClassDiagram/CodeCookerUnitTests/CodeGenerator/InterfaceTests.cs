using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeCooker.Models;
using CodeCooker.Models.ClassDiagram;

namespace CodeCookerUnitTests.CodeGenerator
{
    [TestClass]
    public class InterfaceTests
    {
        [TestMethod]
        public void SingleInterface()
        {
            DocumentModel frontEndDom = new DocumentModel();
            InterfaceModel interfaceModel = new InterfaceModel();
            interfaceModel.id = 1;
            interfaceModel.Name = "interface";
            interfaceModel.Methods = new System.Collections.Generic.List<Method>();
            interfaceModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int" });
            frontEndDom.interfaceList.Add(interfaceModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 0);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 1);

            Assert.AreEqual(stubCodeGen.interfaces[0].Name.CompareTo("interface"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
        }

        [TestMethod]
        public void SingleNoMethodsInterface()
        {
            DocumentModel frontEndDom = new DocumentModel();
            InterfaceModel interfaceModel = new InterfaceModel();
            interfaceModel.id = 1;
            interfaceModel.Name = "interface";
            interfaceModel.Methods = new System.Collections.Generic.List<Method>();
            frontEndDom.interfaceList.Add(interfaceModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 0);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods.Count, 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].Name.CompareTo("interface"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods.Count, 0);
            
        }

        [TestMethod]
        public void SingleMethodWithReturnInterface()
        {
            DocumentModel frontEndDom = new DocumentModel();
            InterfaceModel interfaceModel = new InterfaceModel();
            interfaceModel.id = 1;
            interfaceModel.Name = "interface";
            interfaceModel.Methods = new System.Collections.Generic.List<Method>();
            interfaceModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int ", Return = "int" });
            frontEndDom.interfaceList.Add(interfaceModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 0);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);

            Assert.AreEqual(stubCodeGen.interfaces[0].Name.CompareTo("interface"), 0);
        }

       
    }
}
