using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeCooker.Models;

namespace CodeCookerUnitTests.CodeGenerator
{
    [TestClass]
    public class Inheritance
    {
        [TestMethod]
        public void NoMethdOveride()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "superClass";
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 :int", Return = "int" });
            classModel.Properties = new System.Collections.Generic.List<Property>();
            ClassModel baseclassModel = new ClassModel();
            baseclassModel.id = 2;
            baseclassModel.Name = "baseClass";
            baseclassModel.Methods = new System.Collections.Generic.List<Method>();
            baseclassModel.Methods.Add(new Method() { Name = "method2", Args = "arg1 : int ", Return = "int" });
            baseclassModel.Properties = new System.Collections.Generic.List<Property>();

            ArrowModel arrow = new ArrowModel();
            arrow.Tail.LockedClass= classModel.id;
            arrow.Head.LockedClass = baseclassModel.id;

            frontEndDom.classList.Add(classModel);
            frontEndDom.classList.Add(baseclassModel);
            frontEndDom.arrowList.Add(arrow);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("superClass"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].BaseClassSet, true);
            Assert.AreEqual(stubCodeGen.classes[0].BaseClass, stubCodeGen.classes[1]);

            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Name.CompareTo("method2"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].Name.CompareTo("baseClass"), 0);
        }

        [TestMethod]
        public void MethdOveride()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "superClass";
            classModel.Methods = new System.Collections.Generic.List<Method>();
            classModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 : int", Return = "int" });
            classModel.Properties = new System.Collections.Generic.List<Property>();
            ClassModel baseclassModel = new ClassModel();
            baseclassModel.id = 2;
            baseclassModel.Name = "baseClass";
            baseclassModel.Methods = new System.Collections.Generic.List<Method>();
            baseclassModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 : int", Return = "int" });
            baseclassModel.Properties = new System.Collections.Generic.List<Property>();

            ArrowModel arrow = new ArrowModel();
            arrow.Tail.LockedClass = classModel.id;
            arrow.Head.LockedClass = baseclassModel.id;

            frontEndDom.classList.Add(classModel);
            frontEndDom.classList.Add(baseclassModel);
            frontEndDom.arrowList.Add(arrow);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.classes.Count, 2);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].Name.CompareTo("superClass"), 0);
            Assert.AreEqual(stubCodeGen.classes[0].BaseClassSet, true);
            Assert.AreEqual(stubCodeGen.classes[0].BaseClass, stubCodeGen.classes[1]);

            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.classes[1].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);

            Assert.AreEqual(stubCodeGen.classes[1].Name.CompareTo("baseClass"), 0);
        }
    }
}
