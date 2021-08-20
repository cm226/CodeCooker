using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.Ajax.Utilities;
using Microsoft.AspNet.SignalR;

namespace CodeCooker.Hubs
{
    public class CollaboratorHub : Hub
    {
        public override Task OnDisconnected()
        {
            User user;

            if(GroupTracker.UserMap.TryGetValue(Context.ConnectionId, out user))
            {
                foreach(string collaberationID in user)
                {
                    Clients.OthersInGroup(collaberationID).UserDisconected(Context.User.Identity.Name);      
                }
                GroupTracker.UserMap.TryRemove(Context.ConnectionId, out user);
            }

            return base.OnDisconnected();
        }

        public override Task OnConnected()
        {
            GroupTracker.UserMap[Context.ConnectionId] = new User();
            return base.OnConnected();
        }

        public void SendChatMessage(string message, string collaberationID)
        {
            // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap[Context.ConnectionId].In_Group(collaberationID))
            {
                Clients.OthersInGroup(collaberationID).OnReceveMessage(Context.User.Identity.Name, message);
            }
            else
            {
                // should consider booting the user since they are up to some shit
            }
        }

        public void SendModelUpdate(string collaberationID,object modelUpdate)
        {
            // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap.ContainsKey(Context.ConnectionId) &&
                GroupTracker.UserMap[Context.ConnectionId].In_Group(collaberationID))
            {
                Clients.OthersInGroup(collaberationID).receveModelUpdate(modelUpdate);
            }
            else
            {
                // should consider booting the user since they are up to some shit
            }
        }

        public void requestFullModel(string collaberationID)
        {
            // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap[Context.ConnectionId].In_Group(collaberationID))
            {
                string groupHost = GroupTracker.Groups[collaberationID].Host;
                Clients.Client(groupHost).receveRequestForCurrentModel(Context.ConnectionId);
            }
            else
            {
                // should consider booting the user since they are up to some shit
            }
        }

        /*
         * RequestModelItemIDSet controls the handing out of IDs that clients for a group 
         * can use. The Ids must be unique between all collabirators so they are allocated 
         * by the server. As a performance enhancement thet are allocated in chuncks
         */
        public async void RequestModelItemIDSet(string collabirationID)
        {
             // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap[Context.ConnectionId].In_Group(collabirationID))
            {
                Group collaberationGroup = GroupTracker.Groups[collabirationID];
                /*
                 * This is a noddy method of ensureing that the verified IDs have been 
                 * initialised before any use of them is permited.
                 * 
                 * A better method would be to create a task that is woken up
                 * on initialisation of the IDs but there could be a large
                 * number of groups running at any one time and i am concerned 
                 * about the overhead of all those tasks. so this is the solution
                 * for the moment.
                 */
                if (!collaberationGroup.VerifiedIdsInitialised())
                {
                    await Task.Delay(1000);
                }

                int idChunkEnd = 0;
                if (collaberationGroup.VerifiedIdsInitialised())
                {
                    idChunkEnd = collaberationGroup.RequestModelItemIdSet();
                }
                // client should interprate -ve ID as invalid.
                Clients.Client(Context.ConnectionId).receveModelIDChunck(idChunkEnd - Group.CHUNK_SIZE, idChunkEnd);
            }
        }

        public async void RequestModelListIDSet(string collabirationID)
        {
             // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap[Context.ConnectionId].In_Group(collabirationID))
            {
                Group collaberationGroup = GroupTracker.Groups[collabirationID];
                /*
                 * This is a noddy method of ensureing that the verified IDs have been 
                 * initialised before any use of them is permited.
                 * 
                 * A better method would be to create a task that is woken up
                 * on initialisation of the IDs but there could be a large
                 * number of groups running at any one time and i am concerned 
                 * about the overhead of all those tasks. so this is the solution
                 * for the moment.
                 */
                if(!collaberationGroup.VerifiedIdsInitialised())
                {
                    await Task.Delay(1000);
                }

                int idChunkEnd = 0;
                if (collaberationGroup.VerifiedIdsInitialised())
                {
                    idChunkEnd = collaberationGroup.RequestModelListIdSet();
                }
                // client should interprate -ve ID as invalid.
                Clients.Client(Context.ConnectionId).receveModelListIDChunck(idChunkEnd - Group.CHUNK_SIZE, idChunkEnd);
            }

        }

        /*
         * Should consider chuncking this request as fullModel in some situations
         * Could grow to be rather large. Even better would be to do the model 
         * initialisation of a new user outside of signalR
         */
        public void SendFullModel(string collaberationID, string ConnectedUser, string fullModel)
        {
            // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap[ConnectedUser].In_Group(collaberationID) &&
                GroupTracker.UserMap[Context.ConnectionId].In_Group(collaberationID))
            {
                Clients.Client(ConnectedUser).receveFullModel(fullModel);
            }
            else
            {
                // should consider booting the user since they are up to some shit
            }
        }

        public void createCollabirationDocument()
        {
            string groupID =  GroupTracker.GenerateGroupID();
            string userID = Context.ConnectionId;
            GroupTracker.Groups[groupID] = new Group(userID);
            GroupTracker.UserMap[userID].Join(groupID);
            Groups.Add(userID, groupID);

            Clients.Caller.newCollabirationID(groupID);
            Clients.Caller.initHostData();
        }

        public void RequestJoinCollabirators(string groupID)
        {
            if (!String.IsNullOrEmpty(groupID) && GroupTracker.Groups.ContainsKey(groupID))
            {
                string groupHost = GroupTracker.Groups[groupID].Host;
                Clients.Client(groupHost).receveJoinRequest(Context.ConnectionId, Context.User.Identity.Name);
            }
            else
            {
                // group not found
            }
        }

        public async Task AcceptJoinCollabirators(string collaberationID, string connectionID)
        {
            await Groups.Add(connectionID, collaberationID);

            GroupTracker.UserMap[connectionID].Join(collaberationID);
            Clients.Client(connectionID).joinRequestAccepted(collaberationID);
            Clients.Group(collaberationID).UserConnected(Context.User.Identity.Name);

        }

        /*
         * This function is called from the client host to initiliase the counts for 
         * the syncornised model IDs
         */
        public void initModelIds(int modelIDstart, int modelListIDstart, string collaberationID)
        {
            // verify the collaberationID to prevent any mischief
            if (GroupTracker.UserMap[Context.ConnectionId].In_Group(collaberationID))
            {
                GroupTracker.Groups[collaberationID].InitModelItemId(modelIDstart);
                GroupTracker.Groups[collaberationID].InitModelListId(modelListIDstart);
            }
            else
            {
                // should consider booting the user since they are up to some shit
            }
        }
    }
}