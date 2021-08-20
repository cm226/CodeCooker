/*
 * ITypeToString.h
 *
 *  Created on: 6 Jan 2013
 *      Author: craig
 */
using CodeDom.OO;
namespace CodeDom
{
public class Type
{
    private const int VALUE_NOT_SET = -2;

    public int Value { get { return this.value; } }
    public string StringValue { get { return this.sVal; } }
    int value = VALUE_NOT_SET;
    string sVal;

    public Type (string value)
    {
        this.sVal = value;
    }

    public Type(int value)
    {
        this.value = value;
    }

    public bool Equals(Type t)
    {
        if ((object)t == null)
        {
            return false;
        }
        if (this.Value == Types.UNSPECIFIED.Value || t.Value == Types.UNSPECIFIED.Value)
            return false; // 2 unspecified values are not considered equal
        else if (this.Value != VALUE_NOT_SET && t.Value != VALUE_NOT_SET)
        {
            return this.Value == t.Value;
        }
        else if (!string.IsNullOrWhiteSpace(this.StringValue))
            return this.StringValue.CompareTo(t.StringValue) == 0;

        return false;
    }
}

public class Types
{
	public Type t;
	public string type;

	public Types(string type)
	{
		this.type = type;
	}
	public Types(Type type)
	{
		this.t = type;
	}
	public Types()
	{
	}

    public static Type UNSPECIFIED = new Type(-1);
    public static Type FLOAT = new Type(0);
    public static Type DOUBLE = new Type(1);
    public static Type INT = new Type(2);
    public static Type STRING = new Type(3);
    public static Type VOID = new Type(4);
    public static Type BOOLEAN = new Type(5);
    public static Type TIME = new Type(6);
    public static Type DATE = new Type(7);
    public static Type DATETIME = new Type(8);

}


public abstract class ItypeToString
{

	public virtual void Dispose()
	{
	}
	public abstract string convertType(Type t, Interface dependantClass);

}

}