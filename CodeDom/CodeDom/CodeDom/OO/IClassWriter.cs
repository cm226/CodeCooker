/*
 * AbstractClass.h
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */



namespace CodeGenerators
{

public abstract class IClassWritter
{

	public abstract void write(string folder);
	public virtual void Dispose()
	{
	}

}

} // namespace CodeGenerators