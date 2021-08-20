using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeCooker.Models;

namespace CodeCookerUnitTests.CodeGenerator
{
    [TestClass]
    public class MethodTests
    {

        [TestMethod]
        public void SingleNoMethods()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 0);
        }


        [TestMethod]
        public void SinglePublicMethod()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int", Vis = "+" });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
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
        public void SinglePublicAbstractMethod()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int ", Vis = "+", Abstract = true });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Abstract, true);
        }

        [TestMethod]
        public void SinglePublicStaticMethod()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int ", Vis = "+", Static = true });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Static, true);
        }

        [TestMethod]
        public void SinglePublicWithReturnMethod()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 : int", Vis = "+", Return = "String" });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Return.Value, CodeDom.Types.STRING.Value);
        }

        [TestMethod]
        public void SinglePrivateMethod()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int ", Vis = "-" });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PrivateMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PrivateMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PrivateMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PrivateMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PrivateMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
        }

        [TestMethod]
        public void SingleProtectedMethod()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "class";
            classModel.Properties = new System.Collections.Generic.List<Property>();
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int", Vis = "#" });
            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces.Count, 0);

            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("class"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].ProtectedMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].ProtectedMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].ProtectedMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].ProtectedMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].ProtectedMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
        }
    }
}
