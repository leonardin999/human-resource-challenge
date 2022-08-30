*** Settings ***
Documentation       Migrate Employee data form legacy thick client HR app
...                 And on the internal HR onboarding API into orgainzation
...                 Automation Anywhere Challenge - Busy Bees Resources Managements.

Library             RPA.Browser.Selenium    auto_close= ${False}
Library             RPA.Tables
Library             RPA.Excel.Files
Library             RPA.Windows
Library             RPA.Desktop


*** Variables ***
${EMPLOYEE_lIST_APP_PATH}       ${CURDIR}${/}EmployeeList.exe
${EMPLOYEE_lIST_APP_TITLE}      Employee Database
${HR_API_URL}                   https://botgames-employee-data-migration-vwsrh7tyda-uc.a.run.app/employees
${HR_WEB_APP_URL}               https://developer.automationanywhere.com/challenges/automationanywherelabs-employeedatamigration.html


*** Tasks ***
Complete Human Resources Challenges
    open Employee List Application
    open Human Resource Web URL


*** Keywords ***
open Employee List Application
    [Documentation]    Insert Anotation here ...
    Windows Run    ${EMPLOYEE_lIST_APP_PATH}    wait_time= 1.0

open Human Resource Web URL
    [Documentation]    Insert Anotatio here ...
    Open Available Browser    ${HR_WEB_APP_URL}    maximized= ${True}
