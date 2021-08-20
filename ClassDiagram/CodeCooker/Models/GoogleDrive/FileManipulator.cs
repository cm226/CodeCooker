using CodeCooker.Models.ClassDiagram;
using Google.Apis.Drive.v2;
using Google.Apis.Drive.v2.Data;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace CodeCooker.Models.GoogleDrive
{
    public class FileManipulator
    {
        private DriveService service;

        public FileManipulator(DriveService service)
        {
            this.service = service;
        }

        public void CreateOrOverwrite(string name, string doc)
        {
            Google.Apis.Drive.v2.FilesResource.ListRequest req =  this.service.Service.Files.List();
            req.Q = String.Format("title = '{0}.coc'", name);
            
            FileList files = req.Execute();
            if (files.Items.Count > 0) // should we check if our query returned more than 1 result? It shouldnt but....
                Write(doc, files.Items[0]);
            else
                Create(name, doc);
        }

        private void Create(string name, string fileContent)
        {
            Google.Apis.Drive.v2.Data.File file = new Google.Apis.Drive.v2.Data.File();
            file.Title = String.Format("{0}.coc", name);
            file.MimeType = "text/plain";
            file.Description = "Class diagram file created by Code Cooker";

            byte[] fileContentBytes = new byte[fileContent.Length * sizeof(char)];
            System.Buffer.BlockCopy(fileContent.ToCharArray(), 0, fileContentBytes, 0, fileContentBytes.Length);
            MemoryStream stream = new MemoryStream(fileContentBytes); 
            try
            {
                FilesResource.InsertMediaUpload request = this.service.Service.Files.Insert(file, stream, file.MimeType);
                request.Upload();
            }
            catch(Exception e)
            {
                // TODO
            }


        }

        private void Write(string fileContent, Google.Apis.Drive.v2.Data.File file)
        {
            byte[] fileContentBytes = new byte[fileContent.Length * sizeof(char)];
            System.Buffer.BlockCopy(fileContent.ToCharArray(), 0, fileContentBytes, 0, fileContentBytes.Length);
            MemoryStream stream = new MemoryStream(fileContentBytes); 
            try
            {
                FilesResource.UpdateMediaUpload request = this.service.Service.Files.Update(file, file.Id, stream, file.MimeType);
                request.Upload();
            }
            catch(Exception e)
            {
                // TODO
            }

        }

        public async Task<GoogleDrive.File> DownloadFile(string googleDriveId)
        {
            FilesResource.GetRequest Filerequest = this.service.Service.Files.Get(googleDriveId);
            Google.Apis.Drive.v2.Data.File file = Filerequest.Execute();
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(new Uri(file.DownloadUrl));
            File driveFile = new File(file.Id);
            driveFile.Name = file.Title;
            Stream fileContentStream = await this.service.Service.HttpClient.GetStreamAsync(file.DownloadUrl);
            using (StreamReader reader = new StreamReader(fileContentStream, Encoding.Unicode))
            { 
                driveFile.Content = reader.ReadToEnd();
            }
            
            return driveFile;

        }
    }
}