import massive.munit.TestSuite;

import ExampleTest;
import musings.ComplexTypesTest;
import musings.ConstantsTest;
import musings.ExprsTest;
import musings.FieldsTest;
import musings.PositionsTest;
import musings.TypePathsTest;
import musings.TypesTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(musings.ComplexTypesTest);
		add(musings.ConstantsTest);
		add(musings.ExprsTest);
		add(musings.FieldsTest);
		add(musings.PositionsTest);
		add(musings.TypePathsTest);
		add(musings.TypesTest);
	}
}
