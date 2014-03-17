module BuildSlave.UI.Base;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;

class UIBase : Composite
{
    this(Composite parent)
    {
        super(parent, SWT.NONE);
    }

    //public struct Position2D
    //{
    //    int x, y;
    //
    //    Position2D opBinary(string op)(immutable Position2D rhs) immutable
    //    {
    //        return mixin("Position2D(x "~op~" rhs.x, y "~op~" rhs.y)");
    //    }
    //
    //    pure Position2D addX(immutable Position2D b) immutable 
    //    {
    //        return Position2D(x + b.x, y);
    //    }
    //
    //    pure Position2D addY(immutable Position2D b) immutable 
    //    {
    //        return Position2D(x, y + b.y);
    //    }
    //}
    //static Position2D BorderMargin = Position2D(12, 12);
    //static Position2D CellSpacing  = Position2D(8, 8);
    //static Position2D CellMinSize  = Position2D(16, 16);

    abstract public bool checkDependencies();

    abstract public void preInitialize();
    abstract public void initialize();
    abstract public void postInitialize();
}