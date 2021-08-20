using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeCooker.Models;

namespace CodeCookerUnitTests.CodeGenerator
{ 
    [TestClass]
    public class DomConverter
    {
        [TestMethod]
        public void SingleClass()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 : int" });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen =new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);

        }

        [TestMethod]
        public void SingleClassTwoArgs()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int,arg2 : float" });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[1].name.CompareTo("arg2"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[1].t.StringValue.CompareTo("float"), 0);

        }

        [TestMethod]
        public void SingleClassTwoMethods()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 : int ,arg2 :  float" });
            classModel.Methods.Add(new Method() { Name = "method2", Args = "arg1 :int , arg2 :float " });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[1].name.CompareTo("arg2"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[1].t.StringValue.CompareTo("float"), 0);

            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[1].Name.CompareTo("method2"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[1].Arguments.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[1].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[1].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[1].Arguments[1].name.CompareTo("arg2"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[1].Arguments[1].t.StringValue.CompareTo("float"), 0);

        }

        [TestMethod]
        public void TwoClassesSingleMethods()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int , arg2 :float " });

            ClassModel classModel2 = new ClassModel();
            classModel2.id = 2;
            classModel2.Name = "class2";
            classModel2.Properties = new System.Collections.Generic.List<Property>();
            classModel2.Methods = new System.Collections.Generic.List<Method>();
            classModel2.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int , arg2 :float " });

            frontEndDom.classList.Add(classModel);
            frontEndDom.classList.Add(classModel2);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 2);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[1].name.CompareTo("arg2"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[1].t.StringValue.CompareTo("float"), 0);

            Assert.AreEqual(stubCodeGen.classes[1].Name.CompareTo("class2"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[1].name.CompareTo("arg2"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[1].t.StringValue.CompareTo("float"), 0);

        }
    }
}
