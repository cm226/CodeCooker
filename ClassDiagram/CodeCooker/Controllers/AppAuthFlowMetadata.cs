using System;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;

using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Auth.OAuth2.Mvc;
using Google.Apis.Drive.v2;
using Google.Apis.Util.Store;
using System.IO;
using System.Threading.Tasks;
using Google.Apis.Json;
using CodeCooker.Models;

namespace Google.Apis.Sample.MVC.Controllers
{
    /*
     * This Class has been created to override the becauviour of the Google data store that creates the data stor in 
     * the application data folder, which is not accessable on the GoDaddy servers.
     */
    class FileDataStore : IDataStore
    {
        readonly string folderPath;
        /// <summary>Gets the full folder path.</summary>
        public string FolderPath { get { return folderPath; } }

        public FileDataStore(String FullFilePath) 
        {
           folderPath = FullFilePath;
            if (!Directory.Exists(folderPath))
            {
                Directory.CreateDirectory(folderPath);
            }
        }

       /// <summary>
        /// Stores the given value for the given key. It creates a new file (named <see cref="GenerateStoredKey"/>) in 
        /// <see cref="FolderPath"/>.
        /// </summary>
        /// <typeparam name="T">The type to store in the data store</typeparam>
        /// <param name="key">The key</param>
        /// <param name="value">The value to store in the data store</param>
        public Task StoreAsync<T>(string key, T value)
        {
            if (string.IsNullOrEmpty(key))
            {
                throw new ArgumentException("Key MUST have a value");
            }

            var serialized = NewtonsoftJsonSerializer.Instance.Serialize(value);
            var filePath = Path.Combine(folderPath, GenerateStoredKey(key, typeof(T)));
            File.WriteAllText(filePath, serialized);
            return TaskEx.Delay(0);
        }

        /// <summary>
        /// Deletes the given key. It deletes the <see cref="GenerateStoredKey"/> named file in <see cref="FolderPath"/>.
        /// </summary>
        /// <param name="key">The key to delete from the data store</param>
        public Task DeleteAsync<T>(string key)
        {
            if (string.IsNullOrEmpty(key))
            {
                throw new ArgumentException("Key MUST have a value");
            }

            var filePath = Path.Combine(folderPath, GenerateStoredKey(key, typeof(T)));
            if (File.Exists(filePath))
            {
                File.Delete(filePath);
            }
            return TaskEx.Delay(0);
        }

        /// <summary>
        /// Returns the stored value for the given key or <c>null</c> if the matching file (<see cref="GenerateStoredKey"/>
        /// in <see cref="FolderPath"/> doesn't exist.
        /// </summary>
        /// <typeparam name="T">The type to retrieve</typeparam>
        /// <param name="key">The key to retrieve from the data store</param>
        /// <returns>The stored object</returns>
        public Task<T> GetAsync<T>(string key)
        {
            if (string.IsNullOrEmpty(key))
            {
                throw new ArgumentException("Key MUST have a value");
            }

            TaskCompletionSource<T> tcs = new TaskCompletionSource<T>();
            var filePath = Path.Combine(folderPath, GenerateStoredKey(key, typeof(T)));
            if (File.Exists(filePath))
            {
                try
                {
                    var obj = File.ReadAllText(filePath);
                    tcs.SetResult(NewtonsoftJsonSerializer.Instance.Deserialize<T>(obj));
                }
                catch (Exception ex)
                {
                    tcs.SetException(ex);
                }
            }
            else
            {
                tcs.SetResult(default(T));
            }
            return tcs.Task;
        }

        /// <summary>
        /// Clears all values in the data store. This method deletes all files in <see cref="FolderPath"/>.
        /// </summary>
        public Task ClearAsync()
        {
            if (Directory.Exists(folderPath))
            {
                Directory.Delete(folderPath, true);
                Directory.CreateDirectory(folderPath);
            }

            return TaskEx.Delay(0);
        }

        /// <summary>Creates a unique stored key based on the key and the class type.</summary>
        /// <param name="key">The object key</param>
        /// <param name="t">The type to store or retrieve</param>
        public static string GenerateStoredKey(string key, Type t)
        {
            return string.Format("{0}-{1}", t.FullName, key);
        }
    }
    
    public class AppAuthFlowMetadata : FlowMetadata
    {
        private static readonly IAuthorizationCodeFlow flow =
            new GoogleAuthorizationCodeFlow(new GoogleAuthorizationCodeFlow.Initializer
            {
                ClientSecrets = new ClientSecrets
                {
#if DEBUG || LAPTOPDEBUG
                    ClientId = "169836514215-5metp9kheuv5d3omt7fibj1o8eb9h4ih.apps.googleusercontent.com",
                    ClientSecret = "BzNn0TiLPG91_Oi4WuHaQvc3"
#else
                    ClientId = "169836514215-sfm4rlc0ivvh1k8pjv3v86vivufs4bv0.apps.googleusercontent.com",
                    ClientSecret = "GTwFsA6TxwfAjSpAJW0MAMi8"
#endif
                                    
                },
                Scopes = new[] { DriveService.Scope.DriveFile, "https://www.googleapis.com/auth/drive.install" },
#if DEBUG || LAPTOPDEBUG

                DataStore = new FileDataStore(SpecialDirectorys.rootFolder + @"\ClassDiagram\CodeCooker\Google.Apis.Sample.MVC")
#else

                DataStore = new FileDataStore(SpecialDirectorys.rootFolder + @"\Google.Apis.Sample.MVC")
#endif
            });

        public override string GetUserId(Controller controller)
        {
            return controller.User.Identity.GetUserName();
        }

        public override IAuthorizationCodeFlow Flow
        {
            get { return flow; }
        }
    }
}