using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace CodeDom.OO.Dom
{
    public class Namespaces : IEnumerable<string>
    {
        private List<string> namespaceList = new List<string>();
        private Regex validNameRexEx = new Regex("^[A-Za-z]+[0-9[A-Za-z]*$");

        public int Count { get { return this.namespaceList.Count; } }

        public Namespaces() 
        {

        }

        public string this[int i]
        {
            get { return this.namespaceList[i]; }
            set { this.namespaceList[i] = value; }
        }

        public void Add(string item)
        {
            if(!string.IsNullOrWhiteSpace(item))
                this.namespaceList.Add(this.clean(item));
        }

        private string clean(string item)
        {
            if(!this.validNameRexEx.IsMatch(item))
            {
                int i;
                // if the first character in the sting is a number then the namespace is invalid
                if (int.TryParse(new String(item[0],1), out i))
                    item = item.Insert(0, "_");
                else
                {
                   char[] invalidChars = new char[29] {'!','"','£','$','%','^','&','*','(',' ',')','-','\t','\\','?',
                                                       '~','\'','[',']','{','}',';',':','<','>','/','¬','`','.'};
                    char[] itemArr = item.ToCharArray();
                   for (i = 0; i < item.Length; i++)
                   {
                       if (invalidChars.Contains(itemArr[i]))
                           itemArr[i] = '_';
                   }
                   item = new string(itemArr);
                }
            }
            return item;
        }

        public IEnumerator<string> GetEnumerator()
        {
            return this.namespaceList.GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return this.namespaceList.GetEnumerator();
        }

        public List<string> ToList()
        {
            return this.namespaceList;
        }
    }
}
