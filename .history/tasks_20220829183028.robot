*** Settings ***
Documentation       Migrate Employee data form legacy thick client HR app
...                 And on the internal HR onboarding API into orgainzation
...                 Automation Anywhere Challenge - Busy Bees Resources Managements.

Library             RPA.Browser.Selenium    auto_close= ${False}
Library             RPA.Tables
Library             RPA.Excel.Files
Library             RPA.Windows
Library             RPA.HTTP
Library             RPA.JSON


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

get Employee ID
    [Documentation]    get current Employee ID on website
    ${id}=    RPA.Browser.Selenium.Get Value    css:input#employeeID
    RETURN    ${id}

get Employee Data
    [Documentation]    Get all information of employees

get HR api Data
    [Documentation]    Deserialize the Response information
    [Arguments]    ${id}
    ${json_data}=    get HR api response    ${id}
    ${dict_data}=    Create Dictionary    phone_number= ${json_data}[phone_number]
    ...    start_date= ${json_data}[start_date]
    RETURN    ${dict_data}

get HR api response
    [Documentation]    Get all information in APIs
    [Arguments]    ${id}
    ${api_url}=    Set Variable    ${HR_API_URL}?${id}
    ${json_data}=    Http Get    ${api_url}
    RETURN    ${json_data.json()}

get Employee App data
    [Documentation]    Get all information in EmployeeList Application
    [Arguments]    ${id}
    Control Window    EMPLOYEE_LIST_APP_TITLE    wait_time=0.2
    Click    id:btnClear    wait_time=0.2
    Set Value    id:txtEmpId    ${id}
    Click    id:btnSearch    wait_time=0.2
    data = {
    "first_name": "txtFirstName",
    "last_name": "txtLastName",
    "email": "txtEmailId",
    "city": "txtCity",
    "zip_code": "txtZip",
    "job_title": "txtJobTitle",
    "department": "txtDepartment",
    "manager": "txtManager",
    "state": "txtState",
    }
    for name, elem_id in data.items():
    data[name] = win_lib.get_value(f"id:{elem_id}")
    return data
