using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.Exceptions
{
    public class CodeDomException: Exception
    {
        public CodeDomException(String message): base(message)
        {

        }
    }
}
