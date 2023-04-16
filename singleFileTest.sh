#!/bin/bash
echo "PID: $$"
trap 'kill -9 $$' SIGINT

orig=$(pwd)
directory="/home/dilan/dafny-verifier"
cp test0.dfy "$directory/test.dfy"

function errorFound() {
    if [ $1 -ne 0 ]
    then
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
ls


javac -cp src/main/java/ -d ./out/ src/main/java/Main/GenerateProgram.java src/main/java/Main/CompareOutputs.java


Dafny /noVerify /compile:3 /compileVerbose:0 test.dfy
errorFound $?

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:go /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
errorFound $?
ls
./test > "outputs/output-go.txt"
errorFound $?

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:js /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
errorFound $?

node test.js > "outputs/output-js.txt"
errorFound $?

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:java /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
errorFound $?

java -jar test.jar > "outputs/output-java.txt"
errorFound $?

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:py /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
errorFound $?

python3 test-py/test.py > "outputs/output-py.txt"
errorFound $?


java -cp out/ Main.CompareOutputs 1
err=$?

cd $orig

if [ $err -eq 1 ]
then
  exit 0
else
  exit 1
fi

