using System.Collections.Generic;



namespace CodeDom.OO
{
public partial class Method
{
    #region Members
    private Type returnType;
    private string name;
    private string content;
    private List<typeName> args = new List<typeName>();
    private List<typeName> baseClassArgs = new List<typeName>();
    #endregion

    #region Properties
    public Type Return
    {
        get { return this.returnType; }
        set { this.returnType = value; }
    }

    public string Name
    {
        get { return this.name; }
        set { this.name = value; }
    }

    public string Content
    {
        get { return this.content; }
        set { this.content = value; }
    }

    public List<typeName> Arguments
    {
        get { return this.args; }
        set { this.args = value; }
    }

    public List<typeName> BaseClassArgs
    {
        get { return this.baseClassArgs; }
        set { this.baseClassArgs = value; }
    }

    public string Comment { get; set; }

    public bool Static { get; set; }
    public bool Abstract { get; set; }

    public bool IsOverriden { get; set; }
    public Method Overriding { get; set; }
    #endregion
    
    public struct typeName 
	{
		public Type t;
		public string name;
	};

	public Method(string name)
	{
        this.IsOverriden = false;
		this.returnType = Types.VOID;
		this.name = name;
	}
	
	public void addArgs(Type t, string name)
	{
		typeName tn = new typeName();
		tn.name = name;
		tn.t = t;
		this.args.Add(tn);
	}
}
}