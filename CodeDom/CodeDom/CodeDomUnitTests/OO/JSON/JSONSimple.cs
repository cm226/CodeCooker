using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.JSON;
using System.IO;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.JSON
{
    [TestClass]
    public class JSONSimple
    {

        [TestMethod]
        public void SingleClass()
        {
            GenericClass gc = new GenericClass("class");
            gc.PublicProperties.Add(new Member(CodeDom.Types.INT, "pow"));
            gc.PublicProperties.Add(new Member(CodeDom.Types.INT, "bang"));
            gc.PublicProperties.Add(new Member(CodeDom.Types.INT, "wallap"));
            Utils.CodeContainsTest containsTest = new Utils.CodeContainsTest();
            containsTest.Lines.Add("\"pow\":\"\",");
            containsTest.Lines.Add("\"bang\":\"\",");
            containsTest.Lines.Add("\"wallap\":\"\"");
            
            Assert.AreEqual(containsTest.Contains(gc, new JSONClass(gc)),true);
        }

        [TestMethod]
        public void TwoClasses()
        {
            GenericClass gc = new GenericClass("class");
            gc.PublicProperties.Add(new Member(CodeDom.Types.INT, "pow"));
            gc.PublicProperties.Add(new Member(CodeDom.Types.INT, "bang"));
            gc.PublicProperties.Add(new Member(CodeDom.Types.INT, "wallap"));

            GenericClass baseClass = new GenericClass("baseClass");
            baseClass.PublicProperties.Add(new Member(CodeDom.Types.FLOAT, "baseStuff"));
            gc.setBaseClass(baseClass);

            Utils.CodeContainsTest containsTest = new Utils.CodeContainsTest();
            containsTest.Lines.Add("\"baseClass\":{");
            containsTest.Lines.Add("\"baseStuff\":\"\"");
            containsTest.Lines.Add("\"pow\":\"\",");
            containsTest.Lines.Add("\"bang\":\"\",");
            containsTest.Lines.Add("\"wallap\":\"\"");

            Assert.AreEqual(containsTest.Contains(gc, new JSONClass(gc)), true);
        }
        
    }
}
