#!/bin/bash
echo "PID: $$"
trap 'kill -9 $$' SIGINT

orig=$(pwd)
directory="/home/dilan/dafny-verifier"
cp test0.dfy "$directory/test.dfy"

function errorFound() {
  echo $1
  if [ $1 -ne 0 ]
  then
    rm -rf test-go || true
    rm -rf test-py || true
    rm -rf test.js || true
    rm -rf test.jar || true
    rm -rf test || true
    rm -rf outputs || true

    cd $orig
    exit 1
  fi
}
cd $directory

rm -rf test-go || true
rm -rf test-py || true
rm -rf test.js || true
rm -rf test || true

rm -rf outputs || true
mkdir outputs


javac -cp src/main/java/ -d ./out/ src/main/java/Main/GenerateProgram.java src/main/java/Main/CompareOutputs.java


Dafny /noVerify /compile:3 /compileVerbose:0 test.dfy > tmp.txt  2>&1
err=$?
errorFound $err

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:go /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  ./test > "outputs/output-go.txt"
  err=$?
  errorFound $?
fi

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:js /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  node test.js > "outputs/output-js.txt"
  err=$?
  errorFound $?
fi

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:java /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  java -jar test.jar > "outputs/output-java.txt"
  err=$?
  errorFound $?
fi

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:py /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  python3 test-py/test.py > "outputs/output-py.txt"
  err=$?
  errorFound $?
fi

java -cp out/ Main.CompareOutputs 1
err=$?

rm -rf test-go || true
rm -rf test-py || true
rm -rf test.js || true
rm -rf test.jar || true
rm -rf test || true
rm -rf outputs || true

cd $orig

if [ $err -eq 1 ]
then
  exit 0
else
  exit 1
fi

