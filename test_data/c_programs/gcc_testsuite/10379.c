



void
foo (long *x, long y, long z)
{
  long a = x[0];
  long b = x[1];
  x[0] = a & ~y;
  x[1] = b & ~z;
}
