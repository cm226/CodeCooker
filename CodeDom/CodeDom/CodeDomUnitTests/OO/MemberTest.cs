using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;

namespace CodeDomUnitTests.OO
{
    [TestClass]
    public class MemberTest
    {
        [TestMethod]
        public void DefaultValuesTest()
        {
            Member member = new Member(CodeDom.Types.DOUBLE, "hello");
            Assert.AreEqual(member.GenericsType, CodeDom.Types.UNSPECIFIED);

            Assert.AreEqual(member.CtorArgs.Count, 0);
            Assert.AreEqual(member.Name.CompareTo("hello"),0);
            Assert.AreEqual(member.Return, CodeDom.Types.DOUBLE);
        }
    }
}
