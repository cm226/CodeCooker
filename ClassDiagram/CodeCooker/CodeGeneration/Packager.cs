using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Web;

namespace CodeCooker.CodeGeneration
{
    public static class DirExtention
    {
        public static void Empty(this System.IO.DirectoryInfo directory)
        {
            foreach (System.IO.FileInfo file in directory.GetFiles()) file.Delete();
            foreach (System.IO.DirectoryInfo subDirectory in directory.GetDirectories()) 
            {
                Empty(subDirectory);
                subDirectory.Delete(true);
            }
        }
    }

    public class Packager
    {
        private string targetFile;
        public string SourceDirectory{private get; set;}

        public string downloadURL
        {
            get 
            {
                Uri url = HttpContext.Current.Request.Url;
                StringBuilder urlString = new StringBuilder();
                urlString.Append(url.Scheme);
                urlString.Append("://");
                urlString.Append(url.Authority);
                urlString.Append("/UserGeneratedCode/");
                urlString.Append(Path.GetFileName(this.targetFile));

                return urlString.ToString();
            }
        }

        public Packager()
        {

        }

        public void Package()
        {
            this.targetFile = String.Format("{0}UserGeneratedCode\\{1}_code.zip", HttpRuntime.AppDomainAppPath,
                                                            Path.GetFileName(this.SourceDirectory));

            if (File.Exists(this.targetFile))
                File.Delete(this.targetFile);

            if (Directory.Exists(this.SourceDirectory))
            {
                ZipFile.CreateFromDirectory(this.SourceDirectory, this.targetFile);
                cleanPackageLocation();
            }
            else
            {
                throw new CodeDom.Exceptions.CodeDomException("Code (10001)");
            }
           
        }

        public void cleanPackageLocation()
        {
            if (Directory.Exists(this.SourceDirectory))
            {
                try
                {
                    System.IO.DirectoryInfo sourceDir = new DirectoryInfo(this.SourceDirectory);
                    sourceDir.Empty();
                    Directory.Delete(this.SourceDirectory, true);
                }
                catch (UnauthorizedAccessException e)
                {
                    // log this as a problem because these files will choke up the server TODO
                }
            }
        }
    }
}