using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Hubs
{
    public class User : IEnumerable<string>
    {
        private ConcurrentBag<string> groups = new ConcurrentBag<string>();

        public bool In_Group(string groupID)
        {
            return this.groups.Contains(groupID);
        }

        public void Join(string groupID)
        {
            this.groups.Add(groupID);
        }

        #region IEnumerable

        public IEnumerator<string> GetEnumerator()
        {
            return this.groups.GetEnumerator();
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return this.groups.GetEnumerator();
        }

        #endregion

    }

    public class Group
    {
        public static int CHUNK_SIZE = 30;
 
        private string _Host;

        private int verifiedModelItemId = -1;
        private int verifiedModelListId = -1;

        public Group(string host)
        {
            this._Host = host;
        }

        public string Host
        {
            get { return this._Host; }
        }

        public int RequestModelItemIdSet()
        {
            this.verifiedModelItemId+= CHUNK_SIZE;
            return this.verifiedModelItemId;
        }

        public int RequestModelListIdSet()
        {
            this.verifiedModelListId+= CHUNK_SIZE;
            return this.verifiedModelListId;
        }

        public void InitModelItemId(int value)
        {
            this.verifiedModelItemId = value;
        }

        public void InitModelListId(int value)
        {
            this.verifiedModelListId = value;
        }

        public bool VerifiedIdsInitialised()
        {
            return this.verifiedModelItemId != -1 && this.verifiedModelListId != -1;
        }

    }

    public static class GroupTracker
    {
        public static ConcurrentDictionary<string, User> UserMap
            = new ConcurrentDictionary<string, User>();

        public static ConcurrentDictionary<string, Group> Groups
            = new ConcurrentDictionary<string, Group>();

        public static string GenerateGroupID()
        {
            return Guid.NewGuid().ToString("N");
        }


    }
}