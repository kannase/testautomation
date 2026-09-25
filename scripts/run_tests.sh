#!/bin/bash
echo "Starting mobile test execution"

#Run pytest and output the results in junit.xml format for jenkins
sh 'python3 -m pytest tests/ --junit.xml=reports/junit_reports.xml' --alluredir=allure-results

echo "tests completed" 