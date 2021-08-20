/*
 * ICodeGenerator.cpp
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */

using System;
namespace CodeDom
{
public class ICodeGenerator
{
    protected Uri directory;

	public ICodeGenerator(string fileName)
	{
        this.directory = new Uri(fileName);
	}
}
}