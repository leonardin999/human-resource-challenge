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
Library             String
Library             Collections


*** Variables ***
${EMPLOYEE_lIST_APP_PATH}       ${CURDIR}${/}EmployeeList.exe
${EMPLOYEE_lIST_APP_TITLE}      Employee Database
${HR_API_URL}                   https://botgames-employee-data-migration-vwsrh7tyda-uc.a.run.app/employees
${HR_WEB_APP_URL}               https://developer.automationanywhere.com/challenges/automationanywherelabs-employeedatamigration.html
${NUMBER_OF_EMPLOYEES}          ${10}


*** Tasks ***
Complete Human Resources Challenges
    open Employee List Application
    open Human Resource Web URL
    complete all employee details    ${NUMBER_OF_EMPLOYEES}
    take screenshot of results
    [Teardown]    Close Application


*** Keywords ***
open Employee List Application
    [Documentation]    Insert Anotation here ...
    Windows Run    ${EMPLOYEE_lIST_APP_PATH}    wait_time= 1.0

open Human Resource Web URL
    [Documentation]    Insert Anotatio here ...
    Open Available Browser    ${HR_WEB_APP_URL}    headless=${False}    maximized= ${True}

complete all employee details
    [Documentation]    For each information complete detail of process
    [Arguments]    ${NUMBER_OF_EMPLOYEES}
    FOR    ${employee}    IN RANGE    ${NUMBER_OF_EMPLOYEES}
        complete employee details
    END

complete employee details
    [Documentation]    Insert Notation here
    ${id}=    get Employee ID
    ${employee_data}=    get Employee App data    ${id}
    Fill in employee data    ${employee_data}

get Employee ID
    [Documentation]    get current Employee ID on website
    ${id}=    RPA.Browser.Selenium.Get Value    css:input#employeeID
    RETURN    ${id}

get Employee Data
    [Documentation]    Get all information of employees
    [Arguments]    ${id}
    ${hr_api_data}= get HR api Data    ${id}
    ${employee_app_data} = get Employee App data    ${id}
    RETURN    ${hr_api_data}    ${employee_app_data}

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
    Control Window    ${EMPLOYEE_LIST_APP_TITLE}    wait_time=0.2
    Click    id:btnClear    wait_time=0.2
    Set Value    id:txtEmpId    ${id}
    Click    id:btnSearch    wait_time=0.2
    &{data}=    Create Dictionary    first_name=txtFirstName
    ...    last_name=txtLastName
    ...    email=txtEmailId
    ...    city=txtCity
    ...    zip_code=txtZip
    ...    job_title=txtJobTitle
    ...    department=txtDepartment
    ...    manager=txtManager
    ...    state=txtState
    &{data_inputted}=    Create Dictionary
    FOR    ${item}    IN    @{data}
        ${location}=    Format String    id:{element}    element=${data}[${item}]
        ${value}=    RPA.Windows.Get Value    ${location}
        Set To Dictionary    &{data_inputted}    ${item}= ${value}
    END
    RETURN    &{data}

Fill in employee data
    [Documentation]    insert information of employee in Web form.
    [Arguments]    ${employee}
    Input Text    css:#firstName    ${employee}[first_name"]
    Input Text    css:#lastName    ${employee}[last_name"]
    Input Text    css:#phone    ${employee}[phone_number"]
    Input Text    css:#email    ${employee}[email"]
    Input Text    css:#city    ${employee}[city"]
    Input Text    css:#zip    ${employee}[zip_code"]
    Input Text    css:#title    ${employee}[job_title"]
    Input Text    css:#startDate    ${employee}[start_date"]
    Input Text    css:#manager    ${employee}[manager"]
    Select From List By Value    css:#state    ${employee}[state"]
    Select From List By Value    css:#department    ${employee}[department"]
    Click Button    css:#submitButton

take screenshot of results
    [Documentation]    Take screenshot after filll information
    Wait Until Element Is Visible    css:.modal-confirm
    RPA.Browser.Selenium.Screenshot    filename= ${OUTPUT_DIR}${\}result.png

Close Application
    Close Current Window
    Close All Browsers
