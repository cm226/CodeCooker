using System;
using System.Collections;
using CodeCooker.Models;
using CodeCooker.Models.ClassDiagram;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeCookerUnitTests.CodeGenerator
{
    [TestClass]
    public class ImplementInterface
    {
        [TestMethod]
        public void ImplementSingleInterface()
        {
        
            DocumentModel frontEndDom = new DocumentModel();
            InterfaceModel indertfaceModel = new InterfaceModel();
            indertfaceModel.id = 1;
            indertfaceModel.Name = "superClass";
            indertfaceModel.Methods = new System.Collections.Generic.List<Method>();
            indertfaceModel.Methods.Add(new Method() { Name = "method1", Args = "arg1 : int", Return = "int" });


            InterfaceModel baseInterfaceModel = new InterfaceModel();
            baseInterfaceModel.id = 2;
            baseInterfaceModel.Name = "baseClass";
            baseInterfaceModel.Methods = new System.Collections.Generic.List<Method>();
            baseInterfaceModel.Methods.Add(new Method() { Name = "method2", Args = "arg1 : int", Return = "int" });

            ArrowModel arrow = new ArrowModel();
            arrow.Tail.LockedClass = indertfaceModel.id;
            arrow.Head.LockedClass = baseInterfaceModel.id;

            frontEndDom.interfaceList.Add(indertfaceModel);
            frontEndDom.interfaceList.Add(baseInterfaceModel);
            frontEndDom.arrowList.Add(arrow);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();
            domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);

            Assert.AreEqual(stubCodeGen.interfaces.Count, 2);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Name.CompareTo("method1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].Name.CompareTo("superClass"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[0].InterfacesImplemented.Count, 1);
            IEnumerator implementedInterfaces =  stubCodeGen.interfaces[0].InterfacesImplemented.GetEnumerator();
            implementedInterfaces.MoveNext();
            Assert.AreEqual(implementedInterfaces.Current,stubCodeGen.interfaces[1]);

            Assert.AreEqual(stubCodeGen.interfaces[1].PublicMethods.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[1].PublicMethods[0].Name.CompareTo("method2"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[1].PublicMethods[0].Arguments.Count, 1);
            Assert.AreEqual(stubCodeGen.interfaces[1].PublicMethods[0].Arguments[0].name.CompareTo("arg1"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[1].PublicMethods[0].Arguments[0].t.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[1].PublicMethods[0].Return.StringValue.CompareTo("int"), 0);
            Assert.AreEqual(stubCodeGen.interfaces[1].Name.CompareTo("baseClass"), 0);
        
        }
    }
}
