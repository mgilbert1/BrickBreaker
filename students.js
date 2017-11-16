let students = [
    {name: "Stelios", dorm: "Branford"},
    {name: "Maria", dorm: "Cabot"},
    {name: "Anushree", dorm: "Ezra Stiles"},
    {name: "Brian", dorm: "Winthrop"}
];

console.log("Before:")
for (let student of students)
{
    console.log(student.name + " from " + student.dorm);
}
students.sort(cmp);
console.log("After:")
for (let student of students)
{
    console.log(student.name + " from " + student.dorm);
}

function cmp(a, b)
{
    if(a.name < b.name)
        return -1;
    if(a.name > b.name)
        return 1;
    return 0;
}