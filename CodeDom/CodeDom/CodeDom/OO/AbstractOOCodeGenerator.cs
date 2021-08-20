/*
 * AbstractOOCodeGenerator.cpp
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */

namespace CodeDom.OO
{
public abstract class AbstractOOCodeGenerator : ICodeGenerator
{
    public AbstractOOCodeGenerator(string directory)
        : base(directory)
	{
	}

    public abstract void addClass(GenericClass gclass);
    public abstract void addInterface(Interface interfaceModel);
	public abstract void save();
}
}