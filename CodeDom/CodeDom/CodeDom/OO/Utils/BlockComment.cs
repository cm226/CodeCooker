using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Utils
{
    public class BlockComment
    {
        ICodeWritter writer;
        public string comment { get; set; }
        public int CommentWidth;
        public string BeginComment { get; set; }
        public string EndComment { get; set; }
        public char CommentFill { get; set; }

        public BlockComment(ICodeWritter codeWritter, int commentWidth)
        {
            this.writer = codeWritter;
            this.CommentWidth = commentWidth;

            this.BeginComment = "/*";
            this.EndComment = "*/";
            this.CommentFill = '*';
        }

        public void write()
        {
            if (string.IsNullOrWhiteSpace(this.comment))
                return;

            writer.WriteLine("");
            writer.WriteLine("{0}{1}{2}",this.BeginComment,new string(this.CommentFill,this.CommentWidth+4),this.EndComment);
            
            int index = 0;
            int commentLength = this.comment.Length;
            int sectionLength = this.CommentWidth;
            while (index < commentLength)
            {
                if (index + sectionLength > commentLength)
                    sectionLength = commentLength - index;
                else
                    sectionLength = identifyEndOfLastWord(this.comment.Substring(index, sectionLength));

                writer.Write("{0}  ",this.BeginComment);
                writer.WriteNoIndent(this.comment.Substring(index, sectionLength));
                writer.WriteNoIndent(new string(' ', this.CommentWidth - sectionLength)); // pad the end of the comment 
                index += sectionLength;
                writer.WriteLineNoIndent("  {0}",this.EndComment);
            }


            writer.WriteLine("{0}{1}{2}", this.BeginComment, new string(this.CommentFill, this.CommentWidth+4), this.EndComment);
        }

        private int identifyEndOfLastWord(string commentLine)
        {
            int lastWord = commentLine.LastIndexOf(' ')+1;
            if (lastWord == 0)
                lastWord = commentLine.Length;

            if (lastWord > this.CommentWidth)
                lastWord = this.CommentWidth;
            return lastWord;
        }
    }
}
