using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace CodeDomUnitTests.OO.C__
{
    class CPPCompileChecker
    {
        public bool Compiles(Uri location)
        {
            string clLocation = @"C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\";
            if (!Directory.Exists(clLocation))
            {
                clLocation = @"C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin\amd64\";
            }
            string compileCommand = String.Format("\"{2}cl.exe\" /c /I \"{0}\" \"{0}\\{1}\"", 
                                    Path.GetDirectoryName(location.AbsolutePath),
                                    Path.GetFileName(location.AbsolutePath),
                                    clLocation);
            StringBuilder compileLog = new StringBuilder();

            ProcessStartInfo startInfo = new ProcessStartInfo()
            {
                FileName = compileCommand,
                WindowStyle = ProcessWindowStyle.Hidden,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                CreateNoWindow = true
            };


            using (Process process = Process.Start(startInfo))
            {
                //
                // Read in all the text from the process with the StreamReader.
                //
                process.WaitForExit();
                using (StreamReader reader = process.StandardOutput)
                {
                    string result = reader.ReadToEnd();
                    compileLog.Append(result);
                }
            }

            string logStr = compileLog.ToString();
            if(logStr.Contains("error") || logStr.Contains("warning"))
                return false;

            return true;
        }

        private void onData(object sender, DataReceivedEventArgs e)
        {
            int i = 0;
            i++;
        }
    }
}
