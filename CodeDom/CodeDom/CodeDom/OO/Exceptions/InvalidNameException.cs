using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDomUnitTests.OO.Exceptions
{
    public class InvalidNameException : CodeDom.Exceptions.CodeDomException
    {
        public InvalidNameException(string message)
            :base("Invalid Name: "+message)
        {

        }
    }
}
