using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO.Utils;
using CodeDomUnitTests.Utils;

namespace CodeDomUnitTests.OO.Shared
{
    [TestClass]
    public class BlockCommentTests
    {
        [TestMethod]
        public void ExtraLongLineComment()
        {
            StubCodeWritter codeWritter = new StubCodeWritter();
            BlockComment comment = new BlockComment(codeWritter,40);

            comment.comment = "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD";
            comment.write();

            string commentStr = codeWritter.Content.ToString();
            Assert.AreEqual(commentStr.Contains("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"), true);


        }
    }
}
