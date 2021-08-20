using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeCooker.Models;

namespace CodeCookerUnitTests.CodeGenerator.Exceptional
{
    [TestClass]
    public class Method
    {
        [TestMethod]
        public void InvalidArgumentFormat()
        {
            DocumentModel frontEndDom = new DocumentModel();
            ClassModel classModel = new ClassModel();
            classModel.id = 1;
            classModel.Name = "superClass";
            classModel.Methods = new System.Collections.Generic.List<CodeCooker.Models.Method>();
            classModel.Methods.Add(new CodeCooker.Models.Method() { Name = "method1", Args = "int arg1", Return = "int" });

            frontEndDom.classList.Add(classModel);

            CodeCooker.CodeGeneration.DomConverter domConverter = new CodeCooker.CodeGeneration.DomConverter();
            StubCodeGen stubCodeGen = new StubCodeGen();

            bool exceptionThrown = false;
            try
            {
                domConverter.convertDocumentToDom(frontEndDom, stubCodeGen);
            }
            catch
            {
                exceptionThrown = true;
            }
            Assert.AreEqual(exceptionThrown, true);

        }
    }
}
