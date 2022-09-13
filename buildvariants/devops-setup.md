# DevOPS Setup

## Code Metrics

VSCodes task executes

flutter analyze > ./reports/analyzer_report.txt

To get an analyze report from dart analyzer

VSCode task executes

flutter pub run dart_code_metrics:metrics analyze lib --reporter=html --output-directory=./reports/metrics 

To get dart code metrics

VSCode task executes

flutter test --coverage --reporter=expanded --coverage-path=./reports/coverage/lcov.info 

and

perl C:\ProgramData\chocolatey\lib\lcov\tools\bin\genhtml reports\coverage\lcov.info -o reports\coverage\html

To get test coverage reports, if no tests cover code outputs
lcov.info of zero and no html report

## UML Diagrams

VSCode task executes

flutter pub global run dcdg --search-path=lib --output=reports/docs/diagrams/src/diagrams.puml

And then VSCode UML program used to generate the png