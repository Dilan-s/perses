#!/bin/bash
echo "PID: $$"
trap 'kill -9 $$' SIGINT

source ~/.profile

rm -rf persesOutputs || true
mkdir persesOutputs

Dafny /noVerify /compile:3 /compileVerbose:0 testPerses.dfy > tmp.txt  # 2>&1
if [ $? -ne 0 ]
then
  exit 1
fi
echo "testPerses.dy validated correctly"

cp -r /home/ds1619/dafny_validator .
cd dafny_validator
python3 dafny_validator.py ../testPerses.dfy
if [ $? -ne 0 ]
then
    cd ..
    rm -rf dafny_validator || true
    echo "testPerses.dfy prints incorrect type"
    exit 1
fi
cd ..
rm -rf dafny_validator || true
echo "testPerses.dfy prints correct types"


Dafny /noVerify /compileTarget:go /spillTargetCode:3 testPerses.dfy > tmp.txt # 2>&1
if [ $? -eq 0 ]
then
  mkdir test-go-run
  cp -R testPerses-go/* test-go-run/
  rm -rf testPerses-go || true
  cd test-go-run/src
  go mod init src > tmp.txt # 2>&1
  go mod tidy
  cd ..
  find ./src \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/_System "System_"/_System "src\/System_"/g' > tmp.txt # 2>&1
  find ./src \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -i 's/_dafny "dafny"/_dafny "src\/dafny"/g' > tmp.txt # 2>&1
  cd src
  go build testPerses.go > tmp.txt # 2>&1
  if [ $? -eq 0 ]
  then
    cd ../..
    if [ $? -eq 0 ]
    then
      ./test-go-run/src/testPerses > "persesOutputs/output-go.txt"
      echo "go file created correctly"
    fi
  fi
  rm -rf test-go-run || true
fi


npm install bignumber.js > tmp.txt # 2>&1
Dafny /noVerify /compileTarget:js /compile:2 /compileVerbose:0 testPerses.dfy > tmp.txt  # 2>&1
if [ $? -eq 0 ]
then
    node testPerses.js > "persesOutputs/output-js.txt"
    echo "js file created correctly"
    rm -rf testPerses.js || true
fi

Dafny /noVerify /compileTarget:java /compile:2 /compileVerbose:0 testPerses.dfy > tmp.txt  # 2>&1
if [ $? -eq 0 ]
then
    java -jar testPerses.jar > "persesOutputs/output-java.txt"
    echo "java file created correctly"
    rm -rf testPerses.jar || true
    rm -rf testPerses-java || true
fi

Dafny /noVerify /compileTarget:py /compile:2 /compileVerbose:0 testPerses.dfy > tmp.txt  # 2>&1
if [ $? -eq 0 ]
then
  python3 testPerses-py/testPerses.py > "persesOutputs/output-py.txt"
  echo "py file created correctly"
  rm -rf testPerses-py || true
fi

for file in persesOutputs/*; do
    for file2 in persesOutputs/*; do
	echo "Testing diff between files $file and $file2"
	diff $file $file2 > tmp.txt
	if [ $? -ne 0 ]
	then
	    echo "diff found between files $file and $file2"
	    rm -rf persesOutputs || true
	    exit 0
	fi
    done
done
rm -rf persesOutputs || true
exit 1
