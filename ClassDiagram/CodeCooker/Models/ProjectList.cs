using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public class ProjectList : IEnumerable<KeyValuePair<string, string>>
    {
        private Dictionary<string, string> _ids = new Dictionary<string, string>();

        public ProjectList()
        {

        }

        public void addProject(string projectFolderID, string projectName)
        {
            this._ids.Add(projectFolderID, projectName);
        }

        #region IEnumerator
        public IEnumerator<KeyValuePair<string,string>> GetEnumerator()
        {
            return this._ids.GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return this._ids.GetEnumerator();
        }

        #endregion
    }
}