from mflowgen.assertions import File

def test_basic_file_exists():
  with open( 'exists.txt', 'w' ) as fd:
    fd.write( 'hello world' )
  assert File( 'exists.txt' )

def test_basic_file_not_exists():
  assert not File( 'not-exists.txt' )

def test_basic_file_contains():
  with open( 'contains.txt', 'w' ) as fd:
    fd.write( 'hello world' )
  assert 'hello' in File( 'contains.txt' )

def test_basic_file_not_contains():
  with open( 'not-contains.txt', 'w' ) as fd:
    fd.write( 'hello world' )
  assert 'error' not in File( 'not-contains.txt' )

def test_basic_file_expr():
  with open( 'expr.txt', 'w' ) as fd:
    fd.write( 'hello all' )
  assert 'error' not in File( 'expr.txt' ) and 'all' in File( 'expr.txt' )
  assert 'hello'     in File( 'expr.txt' ) and 'all' in File( 'expr.txt' )

def test_basic_file_lines():
  with open( 'lines.txt', 'w' ) as fd:
    fd.write( 'hello\n' )
    fd.write( 'world\n' )
    fd.write( 'everybody\n' )
    fd.write( '!' )
  count = 0 # count how many lines
  for line in File( 'lines.txt' ):
    count += 1
  assert count == 4

