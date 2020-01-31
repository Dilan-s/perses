


typedef struct
{
  unsigned short b0:1;
  unsigned short b1:1;
  unsigned short b2:1;
  unsigned short b3:1;
  unsigned short b4:1;
  unsigned short b5:1;
  unsigned short b6:1;
  unsigned short b7:1;
  unsigned short b8:1;
  unsigned short b9:1;
  unsigned short b10:1;
  unsigned short b11:1;
  unsigned short b12:1;
  unsigned short b13:1;
  unsigned short b14:1;
  unsigned short b15:1;
} BitField;


unsigned short *p = (unsigned short *) 0x7f14;

void
Do (void)
{
  (*((volatile BitField*)0x7f14)).b0 = 1;
}

int
main (void)
{
  *p = 0x1234;
  Do ();
  return (*p == 0x1235) ? 0 : 1;
}