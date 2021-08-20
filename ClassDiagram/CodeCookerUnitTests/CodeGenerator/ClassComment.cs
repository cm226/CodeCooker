using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;

namespace CodeCookerUnitTests.CodeGenerator
{
    [TestClass]
    public class ClassComment
    {
        [TestMethod]
        public void Comment()
        {
            CodeCooker.CodeGeneration.DomConverter converter = new CodeCooker.CodeGeneration.DomConverter();
            CodeCooker.Models.DocumentModel model = new CodeCooker.Models.DocumentModel();
            model.classList.Add(new CodeCooker.Models.ClassModel() { id = 0, Comment = "test"});
            StubCodeGen codeGen = new StubCodeGen();
            converter.convertDocumentToDom(model, codeGen);

            Assert.AreEqual(codeGen.classes.Count, 1);
            Assert.AreEqual(codeGen.classes[0].ClassComment.CompareTo("test") == 0, true);
            
        }
    }
}
