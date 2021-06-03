<h1>Student Report</h1>

<p>This program sorts a sequential file of student records by their ID, calculates the average of their grades and prints out a report with said information</p>

<h2>Manual</h2>
<p>The application takes as input a file (called "INPUT-STUDENT") containing the following fixed-length fields:</p>

<table>
    <thead>
        <tr>
            <th>Field Name</th>
            <th>Data Type</th>
            <th>Char. Length</th>
            <th>Description</th>
            <th>Notes</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Student ID</td>
            <td>Unsigned Integer (zero fill)</td>
            <td>5</td>
            <td>ID of student</td>
            <td>Nothing to note</td>
        </tr>
        <tr>
            <td>Student Name</td>
            <td>Alphabetic (ASCII)</td>
            <td>30</td>
            <td>First name of student</td>
            <td>Nothing to note</td>
        </tr>
        <tr>
            <td>Student Last Name</td>
            <td>Alphabetic (ASCII)</td>
            <td>30</td>
            <td>Last name of student</td>
            <td>Nothing to note</td>
        </tr>
        <tr>
            <td>Student General Grade</td>
            <td>Unsigned Decimal (zero fill)</td>
            <td>5</td>
            <td>General grade of student</td>
            <td>5.22 === 05220</td>
        </tr>
    </tbody>
</table>

</br>
<p>It also requires the existence of a "WORK-STUDENT" file and a "OUTPUT-STUDENT" file in order to sort the sequential records</p>

<p>Once these two files are set, you just run the program and a report will be created!</p>
