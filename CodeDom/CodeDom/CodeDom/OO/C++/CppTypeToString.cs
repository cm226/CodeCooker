namespace CodeDom.OO
{
public class CppTypeToString : ItypeToString
{
    public override string convertType(Type t, Interface dependantClass)
	{
		if (t.StringValue != null)
		{
			 return t.StringValue;
		}

		if(t == Types.DOUBLE)
			return "double";
		if(t == Types.FLOAT)
		    return  "float";
		if(t == Types.INT)
		    return "int";
        if (t == Types.STRING)
        {
            Dependancy stringDependancy = new Dependancy();
            stringDependancy.StandardDependancy = Dependancy.StandardDependancyValue.STRING;
            dependantClass.Dependancys.Add(stringDependancy);
            return "std::string";
        }
		if(t == Types.VOID)
		    return "void";
        if (t == Types.UNSPECIFIED)
            return "";
        if(t == Types.BOOLEAN)
            return "bool";
        if (t == Types.TIME || t == Types.DATE || t == Types.DATETIME)
        {
            Dependancy stringDependancy = new Dependancy();
            stringDependancy.StandardDependancy = Dependancy.StandardDependancyValue.DATE_TIME;
            dependantClass.Dependancys.Add(stringDependancy);
            return "time_t";
        }
		
		throw new ArgumentExeption("the type is not suported: "+t);
	}
}
}
