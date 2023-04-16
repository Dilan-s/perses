#!/bin/bash
echo "PID: $$"
trap 'kill -9 $$' SIGINT

orig=$(pwd)
directory="/home/dilan/dafny-verifier"
cp test0.dfy "$directory/test.dfy"

function errorFound() {
  if [ $1 -ne 0 ]
  then
    rm -rf test-go || true
    rm -rf test-go-run || true
    rm -rf test-py || true
    rm -rf test.js || true
    rm -rf test.jar || true
    rm -rf test || true
    rm -rf persesOutputs || true

    cd $orig
    exit 1
  fi
}
cd $directory

rm -rf test-go || true
rm -rf test-go-run || true
rm -rf test-py || true
rm -rf test.js || true
rm -rf test || true

rm -rf persesOutputs || true
mkdir persesOutputs


javac -cp src/main/java/ -d ./out/ src/main/java/Main/GenerateProgram.java src/main/java/Main/CompareOutputs.java


./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compile:3 /compileVerbose:0 test.dfy > tmp.txt  2>&1
err=$?
errorFound $err

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:go /spillTargetCode:3 test.dfy > tmp.txt 2>&1
if [ $? -eq 0 ]
then
  mkdir test-go-run
  cp -R test-go/* test-go-run/
  rm -rf test-go || true
  cd test-go-run/src
  go mod init src  > tmp.txt 2>&1
  cd ..
  find ./src \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/_System "System_"/_System "src\/System_"/g'  > tmp.txt 2>&1
  find ./src \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/_dafny "dafny"/_dafny "src\/dafny"/g'  > tmp.txt 2>&1
  cd src
  go build test.go  > tmp.txt 2>&1
  if [ $? -eq 0 ]
  then
    cd ../..
    if [ $? -eq 0 ]
    then
      ./test-go-run/src/test > "persesOutputs/output-go.txt"
      err=$?
      errorFound $err
    fi
  fi
  rm -rf test-go-run || true
fi


./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:js /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  node test.js > "persesOutputs/output-js.txt"
  err=$?
  errorFound $err
fi

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:java /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  java -jar test.jar > "persesOutputs/output-java.txt"
  err=$?
  errorFound $err
fi

./src/main/dafny_compiler/dafny/Binaries/Dafny /noVerify /compileTarget:py /compile:2 /compileVerbose:0 test.dfy > tmp.txt  2>&1
if [ $? -eq 0 ]
then
  python3 test-py/test.py > "persesOutputs/output-py.txt"
  err=$?
  errorFound $err
fi

java -cp out/ Main.CompareOutputs -1 "persesOutputs/"
err=$?

rm -rf test-go || true
rm -rf test-py || true
rm -rf test.js || true
rm -rf test.jar || true
rm -rf test || true
rm -rf persesOutputs || true

cd $orig

if [ $err -eq 1 ]
then
  exit 0
else
  exit 1
fi

