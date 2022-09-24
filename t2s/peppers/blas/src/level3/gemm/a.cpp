template<typename OP>
int do_op(int a, int b, OP op)
{
  return op(a,b);
}
int add(int a, int b) { return a + b; }


int main()
{
int c = do_op(4,5,add);
return c;
}
